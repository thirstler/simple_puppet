class mail (
    $root_aliases = "root",
    $mail_server = "localhost.localdomain",
    $mail_network = "127.0.0.1/32",
    $mail_domain = "localdomain"
) {
    service { 'postfix_service':
        name => 'postfix',
        ensure => true,
        enable => true,
        hasrestart => true
    }
	file { 'postfix_config':
		ensure => present,
		path => '/etc/postfix/main.cf',
		owner => 'root',
		group => 'root',
		mode => '0644',
		seltype => 'postfix_etc_t',
		content => template('mail/postfix_main.cf.erb'),
		notify => Service["postfix_service"]
	}
	file { 'mail_aliases':
	    ensure => present,
		path => '/etc/aliases',
		owner => 'root',
		group => 'root',
		mode => '0644',
		seltype => 'etc_aliases_t',
		content => template('mail/mail_aliases.erb'),
		notify => Service["postfix_service"]
	}
	exec { "newaliases":
        command => "newaliases",
        path    => "/usr/bin/:/bin/",
        refreshonly => true,
        subscribe   => File["/etc/aliases"]
    }
}

