#!/bin/bash

rm -r PublicHeaders
mkdir -p PublicHeaders
find . -name "*.h" -type f -exec ln -s ../{} ./PublicHeaders \;
