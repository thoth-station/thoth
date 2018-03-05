#!/bin/bash

set -ex

workdir=$PWD
virtualenv -p python3 venv
venv/bin/pip3 install Sphinx

mkdir -p thoth/
for repo in `cat registered_repos.txt`; do
	git clone https://github.com/fridex/${repo}.git clones/${repo}
	pushd clones/${repo}/
	$workdir/venv/bin/pip3 install --no-deps .
	popd
	mv clones/${repo}/thoth/* thoth/
done

touch thoth/__init__.py
venv/bin/sphinx-apidoc -F --module-first -o output thoth -H 'Thoth'
PYTHONPATH="${workdir}/venv/lib/python3.6/site-packages" make -C output html


rm -rf ../docs
mv output/_build/html ../docs
rm -rf output venv clones thoth
