
# apache_vhost_facts

This module creates a fact named `apache_vhosts` which reports vhosts that are currently configured in apache e.g.

```
apache_vhosts => {
  ssl2.example.com => {
    ip => "10.0.2.15",
    port => "443",
    default => true
  },
  bar.example.com => {
    ip => "*",
    port => "1234",
    default => true
  },
  bot.example.com => {
    ip => "*",
    port => "1234",
    default => false
  },
  default => {
    ip => "*",
    port => "80",
    default => true
  },
  foo.example.com => {
    ip => "*",
    port => "80",
    default => false
  },
  ssl.example.com => {
    ip => "*",
    port => "443",
    default => true
  }
}
}
```

It works by calling `apachectl -S` and parsing the output. The `default` key indicates whether the vhost is the default for that port.
