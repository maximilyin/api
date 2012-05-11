#!/bin/sh
wget --no-proxy '*' --post-file $1 http://localhost:8080/
