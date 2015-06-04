# Where to checkout to the Git repo.
$newts_git_url = 'https://github.com/OpenNMS/newts.git'
$newts_local_repo = '/home/vagrant/newts'
$newts_install_sh = "${newts_local_repo}/install.sh"

# Where the newts binaries and config files will live
$newts_home = "/opt/newts"
$newts_init = "${newts_home}/bin/init"
$newts_bin = "${newts_home}/bin/newts"
$newts_config = "${newts_home}/etc/config.yaml"

# apt-get install maven git
package {
  'maven':
    ensure  => latest,
    require => Class['java'];
  'git':
    ensure => latest;
  'curl':
    ensure => latest;
}

# git clone https://github.com/OpenNMS/newts.git
vcsrepo { $newts_local_repo:
  ensure   => latest,
  user     => vagrant,
  provider => git,
  source   => $newts_git_url,
  revision => $newts_git_branch,
  require  => [
    Package['git']
  ]
}

# mvn clean install
exec { 'build_newts':
  cwd     => $newts_local_repo,
  command => "mvn clean install",
  path    => "/usr/local/bin/:/usr/bin:/bin/",
  user    => vagrant,
  creates => $newts_target_jar,
  require => [Package['maven'], Vcsrepo[$newts_local_repo]],
  subscribe => Vcsrepo[$newts_local_repo]
}

# cp install.sh /home/vagrant/newts/
file { $newts_install_sh:
  ensure  => present,
  content => template('install.sh.erb'),
  mode    => 755,
  require => Exec['build_newts']
}

# /home/vagrant/newts/install.sh
exec { 'install_newts':
  cwd     => $newts_local_repo,
  command => $newts_install_sh,
  creates => [$newts_init, $newts_bin, $newts_home],
  require => Exec['build_newts']
}

file { $newts_home:
  ensure => present,
  require => Exec['install_newts']
}

# echo <config> > config.yaml
file { $newts_config:
  ensure => present,
  content => template('config.yaml.erb'),
  require => File[$newts_home]
}

# /opt/newts/bin/init /opt/newts/etc/config.yaml
exec { 'init_newts':
  cwd     => $newts_home,
  # Wait for the RPC port to be opened by the Cassanda service - it may take a few seconds after the service was started
  command => "sleep 10 && ${newts_init} ${newts_config} && touch ${newts_home}/initialized",
  path    => "/usr/local/bin/:/usr/bin:/bin/",
  creates => "${newts_home}/initialized",
  require => [File[$newts_config], Service['cassandra']]
}

# /opt/newts/bin/newts -D -c /opt/newts/etc/config.yaml
exec { 'start_newts':
  cwd     => $newts_home,
  command => "${newts_bin} -D -c ${newts_config}",
  path    => "/usr/local/bin/:/usr/bin:/bin/",
  require => Exec['init_newts']
}

# cp
file { "${newts_home}/samples.txt":
  ensure  => file,
  source  => '/vagrant/files/samples.txt',
  owner   => root,
  group   => root,
  mode    => 644
}

# Add the sample measurements
exec { 'newts_sample_data':
  cwd     => $newts_home,
  # Wait for the HTTP port to be opened by the Newts service - it may take a few seconds after the service was started
  command => "sleep 10 && curl -X POST -H 'Content-Type: application/json' -d @samples.txt http://0.0.0.0:8080/samples && touch ${newts_home}/sampled",
  path    => "/usr/local/bin/:/usr/bin:/bin/",
  creates => "${newts_home}/sampled",
  require => [Exec['start_newts'], Package['curl']],
}

# Hack used to trigger a delayed `/etc/init.d/newts start` in hope that Cassandra is up and running
file { '/etc/rc.local':
  ensure  => file,
  source  => '/vagrant/files/rc.local',
  owner   => root,
  group   => root,
  mode    => 755
}

