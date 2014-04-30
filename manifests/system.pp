class timeandlocale {
  package {
    "tzdata":
      ensure => latest;
    "locales":
      ensure => latest;
  }

  file { "/etc/locale.gen":
    content => "",
  }

  exec { "/usr/sbin/locale-gen en_US en_US.UTF-8":
    subscribe   =>  File["/etc/locale.gen"],
    refreshonly =>  true,
    require     =>  Package["locales"],
  }

  exec { "/usr/sbin/dpkg-reconfigure locales":
    subscribe   =>  Exec["/usr/sbin/locale-gen en_US en_US.UTF-8"],
    refreshonly =>  true,
  }

  file { "/etc/localtime":
    source  =>  "file:///usr/share/zoneinfo/America/Montreal",
    require =>  Package["tzdata"],
  }
}

include timeandlocale
