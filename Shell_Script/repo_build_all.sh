#!/bin/bash

# Depend on codebase path
ROOT=/home/lightcheng/work/Disk2/Projects/BT52_1420/

# Clean build for each git project
CLEAN_BUILD=1

# No need to modify
#==============================================
JAVA_LIST="$ROOT"/javarepo_all.txt
LOG_DIR="$ROOT"/buildlog
BUILD_LOG_DIR="$LOG_DIR"/"$REPO_PATH"
BUILD_LOG="$BUILD_LOG_DIR"/buildlog.txt
OUT_COMMON="$ROOT"/out/target/common/
JAR_FILES="$BUILD_LOG_DIR"/jar_files.txt

HAS_JAVA_FILE=0

echo "========================================="
echo "project: $REPO_PATH"
grep "^$REPO_PATH" -q "$JAVA_LIST" && HAS_JAVA_FILE=1
if [ "$HAS_JAVA_FILE" == "1" ]; then
    echo "$REPO_PATH has java!!!!!!!"

    # Env
    mkdir -p "$BUILD_LOG_DIR"
    pushd "$ROOT"
    . ./ccienv/msm8952_env 3 1 2 2 > /dev/null 2>&1
    popd

    # Build
    time mma -j4 > "$BUILD_LOG" 2>&1

    # Find all jar files
    find "$OUT_COMMON" -name classes-full-debug.jar > "$JAR_FILES"
    pushd "$ROOT"
    ./ccienv/findbugs/findbug_with_dir.sh
    popd
    
    # Clean objects
    if [ "$CLEAN_BUILD" == "1" ]; then
        rm -rf "$ROOT"/out
    fi
fi
