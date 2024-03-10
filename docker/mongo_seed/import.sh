#!/bin/bash

mongoimport --username admin --password 123456 --port 27017 --db CWA --mode upsert --collection taiwan_counties --authenticationDatabase=admin --type json --file /mongo_seed/taiwan_counties.json --jsonArray