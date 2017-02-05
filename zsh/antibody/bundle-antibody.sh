#!/bin/sh

antibody bundle < "bundles.txt" > ~/.antibody-bundled-bundles.txt
antibody bundle sindresorhus/pure >> ~/.antibody-bundled-bundles.txt
# Some special packages have to be loaded last
antibody bundle < "last_bundles.txt" >> ~/.antibody-bundled-bundles.txt
