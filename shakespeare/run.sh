#!/usr/bin/env bash
phd dropdb
phd createdb
cat /app/shakespeare.sql | phd psql
pgweb --url $DATABASE_URL --listen=80 --bind=0.0.0.0
