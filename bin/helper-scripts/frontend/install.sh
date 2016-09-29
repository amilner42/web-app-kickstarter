#!/usr/bin/env bash

echo "========================================================"
echo "STARTING TASK: Install frontend npm dependencies"
echo "========================================================"
cd frontend;
npm install;
cd -;
echo "========================================================"
echo "COMPLETE TASK"
echo "========================================================"

echo "========================================================"
echo "STARTING TASK: Install frontend elm dependencies"
echo "========================================================"
cd frontend;
elm package install;
cd -;
echo "========================================================"
echo "COMPLETE TASK"
echo "========================================================"
