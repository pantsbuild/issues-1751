#!/usr/bin/env bash

# This sets up a flat distribution directory for requirements
# that are either unavailable on pypi or else problematic to
# auto-build under pip, pex or pants.

set -e
set -o pipefail

PYTHON=$(which python2.7)

VIRTUALENV=virtualenv-13.1.0
NUMPY_REQ=numpy==1.8.2

PYQUANTE=PyQuante-1.6.5
SCIPY=scipy-0.15.1
MATPLOTLIB=matplotlib-1.1.1

function banner() {
  echo
  echo "== $@ =="
  echo
}

function activate_virtualenv() {
  banner "Creating virtualenv seeded with ${NUMPY_REQ}..."
  local venv=$(mktemp -d -t 'issue_1751.XXXXXX')
  tar -xzf ${VIRTUALENV}.tar.gz && (
    cd ${VIRTUALENV} && \
    ${PYTHON} virtualenv.py ${venv}
  ) && source ${venv}/bin/activate && \
    pip install --upgrade pip setuptools ${NUMPY_REQ}
}

function pyquante_sdist() {
  local dist_dir=$1
  banner "Building ${PYQUANTE} sdist..."
  tar -xzf ${PYQUANTE}.tar.gz && ( 
    cd ${PYQUANTE} && \
    python setup.py sdist && \
    cp -v dist/* ${dist_dir}/
  )
}

function matplotlib_bdist_egg() {
  local dist_dir=$1
  banner "Building ${SCIPY} egg..."
  tar -xzf ${SCIPY}.tar.gz && (
    cd ${SCIPY} && \
    python setupegg.py bdist_egg && \
    cp -v dist/* ${dist_dir}/
  )
}

function scipy_bdist_egg() {
  local dist_dir=$1
  banner "Building ${MATPLOTLIB} egg..."
  tar -xzf ${MATPLOTLIB}.tar.gz && (
    cd ${MATPLOTLIB} && \
    python setupegg.py bdist_egg && \
    cp -v dist/* ${dist_dir}/
  )
}

cd $(git rev-parse --show-toplevel) && \
  cd prebuilts && \
  git clean -ffdx . && \
  DIST_DIR="$(pwd -P)/dist" && \
  mkdir -p ${DIST_DIR} && \
  activate_virtualenv && \
  pyquante_sdist ${DIST_DIR} && \
  matplotlib_bdist_egg ${DIST_DIR} && \
  scipy_bdist_egg ${DIST_DIR}