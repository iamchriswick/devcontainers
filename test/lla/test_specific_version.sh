#!/bin/bash

set -e

source dev-container-features-test-lib

check "lla reports version 0.6.5" bash -c "lla --version | grep 0.6.5"

reportResults
