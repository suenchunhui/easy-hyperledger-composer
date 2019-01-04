#!/bin/bash
MODE=$1
credential_path="./scripts/temp"
 function generateCredentialFiles() {
	user0="admin0"
	pwd0="$(openssl rand -base64 32)"
	user1="admin1"
	pwd1="$(openssl rand -base64 32)"
	user2="admin2"
	pwd2="$(openssl rand -base64 32)"
	user3="admin3"
	pwd3="$(openssl rand -base64 32)"
 	mkdir $credential_path
 	# 0
	cat <<EOF >$credential_path/couchdb0.env
    COUCHDB_USER=$user0
    COUCHDB_PASSWORD=$pwd0
EOF
 	cat <<EOF >$credential_path/peer0.env
    CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$user0
    CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=$pwd0
EOF
 	# 1
	cat <<EOF >$credential_path/couchdb1.env
    COUCHDB_USER=$user1
    COUCHDB_PASSWORD=$pwd1
EOF
 	cat <<EOF >$credential_path/peer1.env
    CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$user1
    CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=$pwd1
EOF
 	# 2
	cat <<EOF >$credential_path/couchdb2.env
    COUCHDB_USER=$user2
    COUCHDB_PASSWORD=$pwd2
EOF
 	cat <<EOF >$credential_path/peer2.env
    CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$user2
    CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=$pwd2
EOF
 	# 3
	cat <<EOF >$credential_path/couchdb3.env
    COUCHDB_USER=$user3
    COUCHDB_PASSWORD=$pwd3
EOF
 	cat <<EOF >$credential_path/peer3.env
    CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$user3
    CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=$pwd3
EOF
}

function removeCredentialFiles() {
	rm -rf $credential_path
}
 if [ "$MODE" == "UP" ]; then
	echo 'Creating CouchDB Credentials...'
	generateCredentialFiles
elif [ "$MODE" == "DONE" ]; then
	echo 'Removing CouchDB Credentials...'
	removeCredentialFiles
fi