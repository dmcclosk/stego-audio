#!/bin/bash
cd "$(dirname "$0")/.."
MATLAB_BIN="/Applications/MATLAB_R2026a.app/bin/matlab"

# For Live Scripts, use desktop mode
"$MATLAB_BIN" -desktop