#!/bin/bash

set -e

source dev-container-features-test-lib

/usr/local/share/lla-config-check.sh || true

check "lla is installed" lla --version
check "hint block in user bashrc" grep -q "# >>> lla-feature >>>" ~/.bashrc

reportResults
