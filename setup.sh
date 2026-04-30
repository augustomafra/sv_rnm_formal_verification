#!/bin/bash

set -euo pipefail

dir=`pwd`
NPROC=1
if [ -n "${1+x}" ]
then
    NPROC="$1"
fi

# 1. MathSAT
export MATHSAT_VERSION="mathsat-5.6.11-linux-x86_64"
export MATHSAT_EXTERNAL_INSTALL_PATH="`pwd -P`/${MATHSAT_VERSION}"
wget "https://mathsat.fbk.eu/release/${MATHSAT_VERSION}.tar.gz"
tar -xf "${MATHSAT_VERSION}.tar.gz"

# 2. Smt-Switch
git clone -b bitwuzla_floating_point_theory https://github.com/augustomafra/smt-switch.git
cd smt-switch
git checkout 5815833ed9b553ef594a8236b1b0ca323fc6c1f5

./contrib/setup-bitwuzla.sh
./contrib/setup-cvc5.sh
ln -s $MATHSAT_EXTERNAL_INSTALL_PATH deps/mathsat
./configure.sh --static --without-tests --no-system-gtest --msat --bitwuzla --cvc5 --prefix=local --smtlib-reader
cd build
make -j"${NPROC}"
make install
cd "${dir}"

# 3. Pono
git clone -b smv_fp_only https://github.com/augustomafra/pono
cd pono
git checkout 3e1453cfa5d18616b05424c8af00d74aa41b4292

./contrib/setup-btor2tools.sh
ln -s `realpath ../smt-switch` deps/smt-switch
ln -s $MATHSAT_EXTERNAL_INSTALL_PATH deps/mathsat
./contrib/setup-ic3ia.sh
./configure.sh --static-lib --static --no-system-gtest --with-msat-ic3ia --with-msat
cd build
make -j"${NPROC}"
make install
cd "${dir}"

# 4. Yosys
git clone -b real_number_formal_modeling https://github.com/augustomafra/yosys
cd yosys
git checkout a726634e9e9883709f94c5e479ce8558af3da704
git submodule update --init --recursive

make config-gcc
make -j"${NPROC}"
make install
