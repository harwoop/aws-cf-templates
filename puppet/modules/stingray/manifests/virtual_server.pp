# == Define: virtual_server
#
# Create a Stingray Traffic Manager virtual server.  A virtual server
# accepts network traffic and processes it. It normally gives each
# connection to a pool; the pool then forwards the traffic to a server node.
#
# === Parameters
#
# [*name*]
# The name of the virtual server.
#
# [*address*]
# The IP Address for this virtual server to listen on.
#
# Valid values are:
#     - '*' which means to listen to all IP Addresses on this host.
#     - A list of Traffic IP Groups prepended with an '!'.
#       For example: address => ['!TIP 1', '!TIP 2'],
#     - A list of IP Address and/or domain names.  The virtual server will
#       take all the traffic on its port for all domain names and IPs listed.
#
# The default value is '*' (listen to all IP Addresses).
#
# [*port*]
# The port this virtual server listens on.  This must be a numerical
# value, it cannot be '*'.  The default is '80'.
#
# [*protocol*]
# The protocol your clients and back-end nodes use. Setting it correctly
# will allow protocol-specific features, such as rules that edit this
# protocol's headers, to work properly. The default value is 'HTTP'.
#
# Valid values are:
#    'HTTP'        'Telnet'             'DNS (TCP)'
#    'FTP'         'SSL'                'SIP (UDP)'
#    'IMAPv2'      'SSL (HTTPS)'        'SIP (TCP)'
#    'IMAPv3'      'SSL (POP3S)'        'RTSP'
#    'IMAPv4'      'SSL (LDAPS)'        'Generic Server First'
#    'POP3'        'UDP -Streaming'     'Generic Client First'
#    'SMTP'        'UDP'                'Generic Streaming'
#    'LDAP'        'DNS (UDP)'
#
# If you're not sure, use 'Generic Streaming'.  The default valus is 'HTTP'.
#
# [*pool*]
# The name of the pool to associate with this virtual server. The default
# pool is 'discard' which drops all traffic.  See pool.pp for more information
# on pools.
#
# [*enabled*]
# Enable this virtual server to begin handling traffic?  The default is 'no'.
#
# [*ssl_decrypt*]
# Should this virtual server decrypt SSL traffic?  This offloads SSL
# processing from your nodes, and allows the virtual server to inspect
# and process the connection.  The default is 'no'.
#
# [*ssl_certificate*]
# The name of the SSL certificate to use when decrypting SSL connections.
# See ssl_certificate.pp for more information on importing SSL
# certificates for use with the Stingray Traffic Manager.
#
# === Examples
#
#  stingray::virtual_server { 'My Virtual Server':
#      address => '!My Traffic IP',
#      pool    => 'My Pool',
#      enabled => 'yes',
#  }
#
#  stingray::virtual_server { 'My SSL Virtual Server':
#      address         => '!My Traffic IP',
#      protocol        => 'HTTP',
#      port            => 443,
#      pool            => 'My Pool',
#      enabled         => 'yes',
#      ssl_decrypt     => 'yes',
#      ssl_certificate => 'My SSL Certificate'
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
define stingray::virtual_server(
    $address = '*',
    $port = 80,
    $protocol = 'http',
    $pool = 'discard',
    $enabled = 'no',
    $ssl_decrypt = 'no',
    $ssl_certificate = undef

) {
    include stingray

    $path = $stingray::install_dir

    # Convert the Protocol to a code that Stingray understands
    case downcase($protocol) {
        'ssl (https)':          {$proto_code = 'https'}
        'ssl (imaps)':          {$proto_code = 'imaps'}
        'ssl (pop3s)':          {$proto_code = 'pop3s'}
        'ssl (ldaps)':          {$proto_code = 'ldaps'}
        'udp - streaming':      {$proto_code = 'udpstreaming'}
        'dns (udp)':            {$proto_code = 'dns'}
        'dns (tcp)':            {$proto_code = 'dns_tcp'}
        'sip (udp)':            {$proto_code = 'sipudp'}
        'sip (tcp)':            {$proto_code = 'siptcp'}
        'generic server first': {$proto_code = 'server_first'}
        'generic client first': {$proto_code = 'client_first'}
        'generic streaming':    {$proto_code = 'stream'}
        default:                {$proto_code = downcase($protocol)}
    }

    info ("Configuring virtual server ${name}")
    file { "${path}/zxtm/conf/vservers/${name}":
        content => template ('stingray/virtual_server.erb'),
    }
}
