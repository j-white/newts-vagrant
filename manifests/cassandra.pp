include apt

apt::key { 'datastax':
  key        => 'B4FE9662',
  key_source => 'http://debian.datastax.com/debian/repo_key',
}

apt::source { 'datastax':
  location   => 'http://debian.datastax.com/community',
  release    => 'stable',
  repos      => 'main',
  key        => 'B4FE9662',
}

package { 'dsc20':
  ensure => 'latest',
  require => Apt::Source['datastax']
}

service { 'cassandra':
  ensure  => 'running',
  enable  => true,
  require => [Package['dsc20'], Class['java']]
}

