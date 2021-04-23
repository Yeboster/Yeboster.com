#!/usr/bin/env sh

# Run migrations
./app/bin/yeboster eval "Yeboster.Release.migrate()"

# DB Seed
./app/bin/yeboster eval "Yeboster.Release.seed_if_needed()"
