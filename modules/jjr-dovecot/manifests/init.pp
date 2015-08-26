class dovecot { 
    package {"dovecot": ensure => installed }
    service { 'dovecot_service':
        name => 'dovecot',
        ensure => true,
        enable => true,
        hasrestart => false
    }
}

