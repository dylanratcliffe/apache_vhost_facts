Facter.add(:apache_vhosts) do
  confine { Facter.value(:apache_version) }

  @unnamed_vhost_line     = %r{^(?<ip>.*):(?<port>\d+)\s+(?<name>.*)\s\((?<location>.*)\)}
  @named_first_line       = %r{^(?<ip>.*):(?<port>\d+)\s+is\sa.*}
  @named_subsequent_lines = %r{^\s+(?<default>(default server)?)(port (?<port>\d+)\snamevhost)?\s(?<name>.*)\s\((?<location>.*:(?<line>\d+))\)}

  def parse(config)
    return_val    = {}
    config_lines  = config.split("\n")
    header_values = {}

    config_lines.each do |line|
      if line =~ @unnamed_vhost_line
        # If this is an unnamed vhost we can get all the details
        match = @unnamed_vhost_line.match(line)
        return_val[match[:name]] = {
          ip: match[:ip],
          port: match[:port],
        }
      elsif line =~ @named_first_line
        match = @named_first_line.match(line)
        # If this is a head line then we set th header values
        header_values = {
          ip: match[:ip],
          port: match[:port],
        }
      elsif line =~ @named_subsequent_lines
        match = @named_subsequent_lines.match(line)
        return_val[match[:name]] = {
          ip: header_values[:ip],
          port: header_values[:port],
        }
      end
    end
    return_val
  end

  setcode do
    if Facter::Util::Resolution.which('apachectl')
      apache_config = Facter::Util::Resolution.exec('apachectl -S 2>&1')
      Facter.debug 'Parsing apache config'
      parse apache_config
    elsif Facter::Util::Resolution.which('apache2ctl')
      apache_config = Facter::Util::Resolution.exec('apache2ctl -S 2>&1')
      Facter.debug 'Parsing apache config'
      parse apache_config
    end
  end
end
