#!/bin/sh

curl -X POST -H "Content-Type: application/json" -d ' { "worldName": "exampleWorld", "ownerPlayerId": "12345", "blocks": [ { "blockMaterial": "stone", "x": 1, "y": 1, "z": 1 }, { "blockMaterial": "chest", "x": -1, "y": -1, "z": -1 } ], "creationId": "hi" }' http://localhost:4500/activate-creation
