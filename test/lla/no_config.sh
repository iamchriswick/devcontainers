#!/bin/bash

set -e

source dev-container-features-test-lib

check "check script is executable" test -x /usr/local/share/lla-config-check.sh
check "check script prints init hint" bash -c "/usr/local/share/lla-config-check.sh; /usr/local/share/lla-config-check.sh | grep -q 'lla init'"
check "hint block exactly once in bashrc" bash -c "[ \$(grep -c \"# >>> lla-feature >>>\" ~/.bashrc) -eq 1 ]"

reportResults
