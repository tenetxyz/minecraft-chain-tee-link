#!/bin/sh

curl -X POST -H "Content-Type: application/json" -d '{ "ownerPlayerId": "3", "creationId": "2" }' http://example.com/api/endpoint
