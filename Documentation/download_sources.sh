#!/bin/bash

set -ex

virtualenv -p python3 venv
source venv/bin/activate

mkdir -p thoth/
for repo in `cat registered_repos.txt`; do
	git clone https://github.com/fridex/${repo}.git clones/${repo}
	pushd clones/${repo}/
	pip3 install --no-deps .
	popd
	mv clones/${repo}/thoth/* thoth/
done

touch thoth/__init__.py
sphinx-apidoc -F --module-first -o output thoth -H 'Thoth'
make -C output html

# Deactivate virtual environment.
deactivate
