class resolv (
    $search_domains = "localdomain",
    $nameservers = ["8.8.8.8"],
    $timeout = "5",
    $attempts = "2"
) {
    file{ '/etc/resolv.conf':
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '0644',
        seltype => 'net_conf_t',
        content => template('resolv/resolv.conf.erb')
    }
}
