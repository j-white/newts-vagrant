include apt

apt::key { 'asf-cassandra-1':
  key        => '2B5C1B00',
  key_server => 'pgp.mit.edu',
}

apt::key { 'asf-cassandra-2':
  key        => '0353B12C',
  key_server => 'pgp.mit.edu',
}

apt::source { 'asf-cassandra':
  location   => 'http://www.apache.org/dist/cassandra/debian',
  release    => '21x',
  repos      => 'main',
  key        => 'F758CE318D77295D',
  key_server => 'pgp.mit.edu',
  require    => [Apt::Key['asf-cassandra-1'], Apt::Key['asf-cassandra-2']]
}

package { 'cassandra':
  ensure => 'latest',
  require => Apt::Source['asf-cassandra']
}

file { '/etc/cassandra/cassandra.yaml':
  ensure  => present,
  require => Package['cassandra']
}

file_line { 'Listen on all addresses':
  path    => '/etc/cassandra/cassandra.yaml',  
  line    => 'rpc_address: 0.0.0.0',
  match   => "^rpc_address.*$",
  require => File['/etc/cassandra/cassandra.yaml']
}

file_line { 'Use a specific broadcast address':
  path    => '/etc/cassandra/cassandra.yaml',  
  line    => 'broadcast_rpc_address: 127.0.0.1',
  match   => ".*broadcast_rpc_address:.*",
  require => File['/etc/cassandra/cassandra.yaml']
}

service { 'cassandra':
  ensure  => 'running',
  enable  => true,
  require => [Package['cassandra'], Class['java'], File_Line['Listen on all addresses'], File_Line['Use a specific broadcast address']]
}

