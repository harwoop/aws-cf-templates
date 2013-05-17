# == Define: new_cluster
#
# Create a new Stingray Traffic Manager cluster.
#
# === Parameters
#
# [*name*]
# The name of the new cluster.
#
# [*admin_password*]
# The administrator password to use.  Defaults to 'password'.
#
# [*license_key*]
# Path to the license key file. Providing no license key file, defaults to
# developer mode.
#
# === Examples
#
#  stingray::new_cluster { 'my_cluster':
#  }
#
#  stingray::new_cluster { 'my_cluster':
#      admin_password => 'my_password',
#      license_key    => 'puppet:///modules/stingray/license.txt'
#  }
#
# === Authors
#
# Faisal Memon <fmemon@riverbed.com>
#
# === Copyright
#
# Copyright 2013 Riverbed Technology
#
define stingray::new_cluster (
    $admin_password = $stingray::params::admin_password,
    $license_key = $stingray::params::license_key

) {
    include stingray
    include stingray::params

    $path = $stingray::install_dir
    $accept_license = $stingray::accept_license

    file { $path:
        ensure => directory,
        alias  => 'new_stingray_cluster_installed',
    }

    if ($license_key != '') {
        file { "${path}/license.txt":
            source  => $license_key,
            before  => [ File['new_stingray_cluster_replay'], ],
            alias   => 'new_stingray_cluster_license',
        }
        $local_license_key = "${path}/license.txt"
    }

    file { "${path}/new_cluster_replay":
        content => template ('stingray/new_cluster.erb'),
        require => [ File['new_stingray_cluster_installed'], ],
        alias   => 'new_stingray_cluster_replay',
    }

    exec { "${path}/zxtm/configure --replay-from=new_cluster_replay":
        cwd     => $path,
        user    => 'root',
        require => [ File['new_stingray_cluster_replay'], ],
        alias   => 'new_stingray_cluster',
        creates => "${path}/rc.d/S10admin",
    }

    if ($license_key == '') {
        file_line { 'developer_license_accepted':
            ensure  => present,
            path    => "${path}/zxtm/conf/zxtms/${::fqdn}",
            line    => 'developer_mode_accepted yes',
            require => [ Exec['new_stingray_cluster'], ],
        }
    }
}
