#!/usr/bin/env sh

# Create database
/app/bin/yeboster eval "Yeboster.Release.create_db_if_needed()"

# Run migrations
/app/bin/yeboster eval "Yeboster.Release.migrate()"

# DB Seed
# /app/bin/yeboster eval "Yeboster.Release.seed_if_needed()"

echo "Starting..."
exec "$@"
