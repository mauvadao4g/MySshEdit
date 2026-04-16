#!/bin/bash


url="https://raw.githubusercontent.com/zumgabutm/donomodderajuda/main/versao"

echo "$url" | sed -E 's#https://raw.githubusercontent.com/([^/]+/[^/]+)/.*#https://github.com/\1#'
