#!/bin/bash

set -e

source dev-container-features-test-lib

mkdir -p ~/.config/lla
touch ~/.config/lla/config.toml

check "check script is silent" bash -c "[ -z \"\$(/usr/local/share/lla-config-check.sh)\" ]"
check "interactive shell prints no notice" bash -c "[ -z \"\$(bash -ic true 2>&1 | grep lla)\" ]"

reportResults
