#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "$(realpath "${BASH_SOURCE[0]}")")" &>/dev/null && pwd)

defaults write org.hammerspoon.Hammerspoon MJConfigFile "$SCRIPT_DIR/init.lua"