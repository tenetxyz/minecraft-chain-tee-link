#!/bin/sh

curl -X POST -H "Content-Type: application/json" -d '{ "ownerPlayerId": "3", "creationId": "hi" }' http://localhost:4500/get-creation-output
