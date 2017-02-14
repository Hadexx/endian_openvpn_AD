# endian_openvpn_AD

#Integration proxy in Active Directoy before.

/var/efw/openvpn/settings

AUTHENTICATION_STACK=ldap,local

# copy archive auth.sh to path /etc/openvpn
# chmod +x auth.sh

/etc/openvpn/openvpn.conf.tmpl

script-security 2

tmp-dir "/dev/shm"

auth-user-pass-verify "/etc/openvpn/auth.sh" via-file
