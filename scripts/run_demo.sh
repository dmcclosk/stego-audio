#!/bin/bash
cd "$(dirname "$0")/.."
MATLAB_BIN="/Applications/MATLAB_R2026a.app/bin/matlab"

# Run headless demo
"$MATLAB_BIN" -batch "addpath('src', 'demos'); run_demo"