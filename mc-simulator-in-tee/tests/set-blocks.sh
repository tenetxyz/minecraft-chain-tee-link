#!/bin/sh

curl -X POST -H "Content-Type: application/json" -d ' { "worldName": "exampleWorld", "ownerPlayerId": "12345", "blocks": [ { "material": "stone", "x": 1, "y": 1, "z": 1 }, { "material": "chest", "x": -1, "y": -1, "z": -1 } ], "creationId": "hi" }' http://localhost:4500/activate-creation
