include apt

apt::key { 'asf-cassandra':
  key        => '2B5C1B00',
  key_server => 'pgp.mit.edu',
}

apt::source { 'asf-cassandra':
  location   => 'http://www.apache.org/dist/cassandra/debian',
  release    => '20x',
  repos      => 'main',
  key        => 'F758CE318D77295D',
  key_server => 'pgp.mit.edu',
  require    => Apt::Key['asf-cassandra'],
}

package { 'cassandra':
  ensure => 'latest',
  require => Apt::Source['asf-cassandra']
}

service { 'cassandra':
  ensure  => 'running',
  enable  => true,
  require => [Package['cassandra'], Class['java']]
}

