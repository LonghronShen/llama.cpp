#!/bin/bash

set -x

apt update

apt install -y build-essential python3-pip aria2

pip3 install cmake
pip3 install -r requirements.txt

export PATH=$PATH:$(pwd)/build/bin
