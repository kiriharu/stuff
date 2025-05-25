#!/bin/bash

TARGET_DIR="$1"
TEST_FILE="${TARGET_DIR}/test.tmp"
BS="1G"
COUNT=1

echo "=== Drop caches... ==="
sh -c 'echo 3 > /proc/sys/vm/drop_caches'

echo "=== Check write speed - dd ==="
sync
dd if=/dev/zero of="$TEST_FILE" bs=$BS count=$COUNT oflag=direct status=progress
sync

echo ""
echo "=== Check read speed - dd ==="
dd if="$TEST_FILE" of=/dev/null bs=$BS count=$COUNT iflag=direct status=progress

echo ""
echo "=== Cleanup... ==="
rm -f "$TEST_FILE"
sh -c 'echo 3 > /proc/sys/vm/drop_caches'
