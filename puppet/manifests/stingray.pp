node 'stingray' {
  host { 'stingray':
    ip => '10.0.0.20',
  }

  class {'stingray':
    accept_license => 'accept',
  }

  stingray::settings { 'My Settings':
    controlallow => 'all'
  }


  stingray::new_cluster{'new_cluster':
  }

  stingray::pool { 'FirstSite-Pool':
    nodes       => ['10.0.0.21:80', '10.0.0.22:80'],
    algorithm   => 'perceptive',
    persistence => 'FirstSite_Persistence',
    monitors    => 'FirstSite_HTTP_Monitor',
  }

  stingray::trafficipgroup { 'FirstSite_TrafficIP':
    ipaddresses => ['10.0.1.100', ],
    machines    => 'stingray',
    enabled     => 'yes'
  }

  stingray::virtual_server { 'FirstSite_Virtual_Server':
    address  => '10.0.1.100',
    protocol => 'HTTP',
    pool     => 'FirstSite-Pool',
    port     => 80,
    enabled  => 'yes'
  }

  stingray::persistence{'FirstSite_Persistence':
    type => 'Transparent session affinity'
  }

  stingray::monitor { 'FirstSite_HTTP_Monitor':
    type       => 'HTTP',
    status_regex => '^[234][0-9][0-9]$',
    path       => '/'
  }

  # install java
  package { jdk:
    ensure => installed,
    name => "java-1.7.0-openjdk"
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto   => 'icmp',
    action  => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }
  firewall { '003 allow ssh access':
    port   => 22,
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '004 allow http and https access':
    port   => [80, 443],
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '100 allow Stingray Admin UI access':
    port   => 9090,
    proto  => 'tcp',
    action => 'accept',
  }  

  firewall { '101 allow Stingray application access':
    port   => 9080,
    proto  => 'tcp',
    action => 'accept',
  }    

  firewall { '102 allow Stingray application access':
    port   => 9080,
    proto  => 'udp',
    action => 'accept',
  }    

  firewall { '103 allow access to custom site.':
    port   => 8000,
    proto  => 'tcp',
    action => 'accept',
  }      

}