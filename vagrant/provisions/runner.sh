#!/usr/bin/env bash

# Error on unset variables.
set -o nounset

# Exit on any errors.
set -o errexit

# Output debug information about the running scripts.
# set -o xtrace

# Tell debian based systems that we're not running an interactive frontend.
export DEBIAN_FRONTEND=noninteractive

# Check we've been called with the correct number of arguments before
# proceeding any further.
if [ $# -eq 0 ]; then
    echo "Runner requires one argument to run, the target script to execute, relative to /vagrant/"
    exit 1;
fi

# Check the target file exists.
if [ ! -f "${1}" ]; then
    echo "Provision [ ${1} ] not found"
    exit 1
fi

# Souce the target to ensure it inherits the rules and environment
# variables established in the runner.
source "${1}" 
