#!/bin/bash

set -euo pipefail

dir=`pwd`
NPROC=1
if [ -n "${1+x}" ]
then
    NPROC="$1"
fi

# 1. MathSAT
if [ -z "${MATHSAT_EXTERNAL_INSTALL_PATH+x}" ]
then
    echo "error: Instal path for MathSAT must be set at environment variable 'MATHSAT_EXTERNAL_INSTALL_PATH'"
    exit 1
fi

# 2. Smt-Switch
git clone -b bitwuzla_floating_point_theory https://github.com/augustomafra/smt-switch.git
cd smt-switch
git checkout bitwuzla_floating_point_theory

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
git checkout smv_fp_only

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
git checkout real_number_formal_modeling
git submodule update --init --recursive

make config-gcc
make -j"${NPROC}"
make install
