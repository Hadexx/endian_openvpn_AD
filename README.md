# endian_openvpn_AD

Integration proxy in Active Directoy before.

/var/efw/openvpn/settings

AUTHENTICATION_STACK=ldap,local

/etc/openvpn/openvpn.conf.tmpl

script-security 2

tmp-dir "/dev/shm"

auth-user-pass-verify "/etc/openvpn/auth.sh" via-file
