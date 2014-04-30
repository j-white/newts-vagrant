import 'system.pp'
import 'java.pp'
import 'cassandra.pp'
import 'newts.pp'

file { '/etc/motd':
  content => "Welcome to NewTS! Managed by Puppet.\n"
}

