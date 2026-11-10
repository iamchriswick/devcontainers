#!/bin/bash

set -e

source dev-container-features-test-lib

check "lla is installed" lla --version

reportResults
