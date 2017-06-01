#!/bin/sh

antibody bundle < "bundles.txt" > ~/.antibody-bundled-bundles.txt
# Use version tag of pure that is NOT broken. Git info disappears for any later version.
antibody bundle sindresorhus/pure branch:v1.5.0 >> ~/.antibody-bundled-bundles.txt
# Some special packages have to be loaded last
antibody bundle < "last_bundles.txt" >> ~/.antibody-bundled-bundles.txt
