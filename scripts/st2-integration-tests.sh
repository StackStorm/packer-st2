#!/bin/bash -eu

echo -e '\033[33mAdd "st2-integration-tests" tool to PATH ...\033[0m'
ln -sf /opt/ova/bin/st2-integration-tests /usr/local/sbin/st2-integration-tests
