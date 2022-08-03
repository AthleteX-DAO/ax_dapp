#!/usr/bin/env bash
sh

# Stop any program currently running on the set port
echo 'preparing port' $PORT '...'
fuser -k $PORT/tcp

# switch directories
cd build/web/

# Start the server
echo 'Server starting on port' $PORT '...'
python3 -m http.server $PORT