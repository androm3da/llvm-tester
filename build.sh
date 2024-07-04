#!/bin/bash

set -euo pipefail

docker build --ulimit nofile=1048576:1048576 -t llvm:latest . 2>&1 | tee build.log
docker create --name llvmb llvm:latest
docker cp llvmb:/tmp/final/*.xz .

