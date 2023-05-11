#!/bin/sh

curl -X POST -H "Content-Type: application/json" -d ' { "worldName": "exampleWorld", "ownerPlayerId": "12345", "blocks": [ { "blockMaterial": "stone", "x": 1, "y": 2, "z": 3 }, { "blockMaterial": "grass", "x": 4, "y": 5, "z": 6 } ] }' http://localhost:4500/activate-creation