#!/usr/bin/env bash

echo "========================================================"
echo "STARTING TASK: Install frontend dependencies"
echo "========================================================"
cd frontend;
npm install;
cd -;
echo "========================================================"
echo "COMPLETE TASK"
echo "========================================================"

echo "========================================================"
echo "STARTING TASK: Install frontend typings"
echo "========================================================"
cd frontend;
"$FRONTEND_NODE_MODULES_BIN"/typings install;
cd -;
echo "========================================================"
echo "COMPLETE TASK"
echo "========================================================"
