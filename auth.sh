#!/bin/bash

TEST_MODE=true # Test mode to use script from command line, being prompted for username and password
#LDAP_SERVER='ldap.example.com'
#BASE_DN='dc=example,dc=com'
#MEMBER_ATTR='memberUid'
#VPN_GROUP='vpnusers'
CRED_FILE="$1" # Temporary file with credentials (username, password) is passed to script as first argument
MAX_LEN=256 # Maximum length in characters of username and password; longer strings will not be accepted


uid=''
pw=''

if $TEST_MODE
  then
  echo "Running in test mode"
  read -p "Username: " uid
  read -s -p "Password: " pw
  echo
elif ! [ -r "$CRED_FILE" ]
  then
  echo "ERROR: Credentials file '${CRED_FILE}' does not exist or is not readable"
  exit 1
elif [ $(wc -l <"CRED_FILE") -ne 2 ]
  then
  echo "ERROR: Credentials file '${CRED_FILE}' does not exactly how two lines of text"
  exit 2
else
  echo "Reading username and password from credentials file '${CRED_FILE}'"
  uid=$(head -n 1 "$CRED_FILE")
  pw=$(tail -n 1 "$CRED_FILE")
fi

if [ $(echo "$uid" | wc -m) -gt $MAX_LEN ]
  then
  echo "ERROR: Username is longer than $MAX_LEN characters - this is forbidden"
  exit 3
fi

if [ $(echo "$pw" | wc -m) -gt $MAX_LEN ]
  then
  echo "ERROR: Password is longer than $MAX_LEN characters - this is forbidden"
  exit 4
fi

# ldapcompare argument format:
# ldapcompare [options] DN attr:value
#
# DN = distinguished name to perform comparison on
# attr:value = name of attribute to check : value to check for
#
# Options used:
# -x Use simple authentication instead of SASL.
# -D LDAP reprentation (DN = distinguished name) of the username used for the LDAP connection
# -w Password used for authentication upon connection to LDAP server

#echo "Running command: ldapcompare -x -H ldap://${LDAP_SERVER} -D \"uid=${uid},ou=people,${BASE_DN}\" -w \"<SECRET>\" \"cn=${VPN_GROUP},ou=groups,${BASE_DN}\" \"${MEMBER_ATTR}:${uid}\""
#RESULT=$(ldapcompare -x -H ldap://${LDAP_SERVER} -D "uid=${uid},ou=people,${BASE_DN}" -w "${pw}" "cn=${VPN_GROUP},ou=groups,${BASE_DN}" "${MEMBER_ATTR}:${uid}")

#echo "LDAP compare result: $RESULT"

#if [ "$RESULT" = 'TRUE' ]
#  then
#  echo "User '${uid}' is a member of group '${VPN_GROUP}'"
#  exit 0
#else
#  echo "ERROR: LDAP connection error or user '${uid}' not in group '${VPN_GROUP}'"
#  exit 5
#fi

RESULT1=$(wbinfo -a ${uid}%${pw})

SUC="succeeded"

if echo "$RESULT1" | grep -q "$SUC"; then
  echo "authentication succeeded.";
  exit 0;
else
  echo "ERROR authentication failed.";
  exit 5;
fi