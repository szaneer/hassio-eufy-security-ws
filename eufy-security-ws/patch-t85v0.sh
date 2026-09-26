#!/bin/sh
# Treat the FamiLock S3 Max (T85V0) as a DoorbellLock so HA gets a lock entity.
# Fails the image build if the upstream code no longer matches.
set -e
F=$(find /usr/src/app/node_modules -path '*eufy-security-client/build/eufysecurity.js' | head -n1)
[ -n "$F" ] || { echo "eufy-security-client build not found" >&2; exit 1; }
OLD='device_1.Device.isLockWifiVideo(device.device_type)) {'
NEW='device_1.Device.isLockWifiVideo(device.device_type) || device_1.Device.isLockWifiT85V0(device.device_type)) {'
grep -qF "$OLD" "$F" || { echo "T85V0 patch: pattern not found in $F" >&2; exit 1; }
sed -i "s/device_1\.Device\.isLockWifiVideo(device\.device_type)) {/device_1.Device.isLockWifiVideo(device.device_type) || device_1.Device.isLockWifiT85V0(device.device_type)) {/" "$F"
grep -qF "$NEW" "$F" || { echo "T85V0 patch: verification failed" >&2; exit 1; }
echo "T85V0 patch applied to $F"
