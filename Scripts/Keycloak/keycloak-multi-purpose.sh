#!/bin/bash
# Author: Christopher Breimo

# This is a multi-purpose script for administrative tasks in Keycloak
# Everything above the dash-lane can be reused for future scripts
# Below the dash-lane are a couple of example requests for reference

# Variables
URL=placeholder.url
REALM=placeholder.realm
CLIENT=security-admin-console
ADMUSER=placeholder.user
read -r -s -p "Enter the password for $ADMUSER: " ADMPASS

# Logging
exec &> keycloak-action-"$REALM".log

# Request a auth-token from Keycloak
## Authenticates towards the master realm. Change this if necessary
RESULT=$(curl -k -s -X POST $URL/auth/realms/master/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "client_id=$CLIENT" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "username=$ADMUSER" \
  --data-urlencode "password=$ADMPASS")

# Filter the token from $RESULT
TOKEN=$(echo "$RESULT" | sed 's/.*access_token":"//g' | sed 's/".*//g')

echo "[Generated token for user $ADMUSER]"
echo "$TOKEN"

# ---------------------------------------------------------------------------------------------------------------

## Create a user in an existing realm
curl -k -X POST $URL/auth/admin/realms/$REALM/users \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  --data "{'username':'username', 'firstName':'firstname', 'lastName':'lastname', 'email':'email', 'enabled':'true'}"

## Add a user to an existing group
curl -k -X PUT $URL/auth/admin/realms/$REALM/users/user-id/groups/group-id \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  --data "{'realm':'$REALM', 'userId':'user-id', 'groupId':'group-id'}"

## Deleting an existing user
curl -k -X DELETE $URL/auth/admin/realms/$REALM/users/user-id \
  -H "Authorization: Bearer $TOKEN"