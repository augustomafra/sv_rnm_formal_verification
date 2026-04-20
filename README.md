[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19168739.svg)](https://doi.org/10.5281/zenodo.19168739)

# Summary
This repository contains the public benchmarks for evaluation of Formal
Verification of Mixed-Signal Systems Using Real Number Modeling on an SMT-Based
Model Checker. It is organized as follows:

- `setup.sh`: Bash script for automatically installing all dependencies. See
Setup section for details about the steps performed here.
- `tests`: directory containing all SystemVerilog RNM benchmarks alongside their
SMV representation and run logs.
- `plot.py`: Python script for parsing run logs and generating CSV summary.
- `results.csv`: Summary of results extracted from all the logs (including from
confidential benchmarks not present in this repository).
- `run.sh`: Main driver Bash script for running all tests.

# Setup
Install MathSAT solver and run `setup.sh N` to perform setup automatically,
where N is the number of parallel build jobs used (default: 1).
Alternatively, the same steps in that script are described below and can be
executed/modified according to your custom needs.

#### 1. MathSAT
1. The installation of MathSAT SMT solver must be obtained independently. User
is responsible for meeting license conditions.
2. The setup steps below assume MathSAT has been installed in the path pointed
by the environment variable `MATHSAT_EXTERNAL_INSTALL_PATH`.

#### 2. Smt-Switch
1. Clone fork of [Smt-Switch](https://github.com/augustomafra/smt-switch/tree/bitwuzla_floating_point_theory) repository and checkout branch
`bitwuzla_floating_point_theory`:
```
git clone -b bitwuzla_floating_point_theory https://github.com/augustomafra/smt-switch.git
cd smt-switch
git checkout bitwuzla_floating_point_theory
```
2. Configure and build Smt-Switch:
```
./contrib/setup-bitwuzla.sh
./contrib/setup-cvc5.sh
ln -s $MATHSAT_EXTERNAL_INSTALL_PATH deps/mathsat
./configure.sh --static --without-tests --no-system-gtest --msat --bitwuzla --cvc5 --prefix=local --smtlib-reader
cd build
make
make install
cd .. # Return to root path
```

#### 3. Pono
1. Clone fork of [Pono](https://github.com/augustomafra/pono/tree/smv_fp_only) repository and checkout branch
`smv_fp_only`:
```
git clone -b smv_fp_only https://github.com/augustomafra/pono
cd pono
git checkout smv_fp_only
```
2. Configure and build Pono. Note that we do not use all settings from Pono's
repository README because we need to link against the Smt-Switch built in step
(2):
```
./contrib/setup-btor2tools.sh
ln -s `realpath ../smt-switch` deps/smt-switch
ln -s $MATHSAT_EXTERNAL_INSTALL_PATH deps/mathsat
./contrib/setup-ic3ia.sh
./configure.sh --static-lib --static --no-system-gtest --with-msat-ic3ia --with-msat
cd build
make
make install
cd .. # Return to root path
```

#### 4. Yosys
1. Clone fork of [Yosys](https://github.com/augustomafra/yosys/tree/real_number_formal_modeling) repository and checkout branch
`real_number_formal_modeling`:
```
git clone -b real_number_formal_modeling https://github.com/augustomafra/yosys
cd yosys
git checkout real_number_formal_modeling
git submodule update --init --recursive
```
2. Configure and build Yosys:
```
make config-gcc
make
make install
```

# Usage
- Run `run.sh` to automatically build and run all benchmarks.
- Resource requirements: this experiment runs using 4 cores in a 64GB machine in
around 120min. Increase the number of cores in the NJOBS variable in `run.sh` for
faster run time if you have more memory available.
## Details
- `make build`: only build benchmarks.
- `make prove | all`: build and run all benchmarks. It is the default target.
- `make backup`: save a `.log.bak` backup file for the current benchmark settings.
- `make clean`: deletes built artifacts. Note: Does not remove `.log` files
  generated from benchmark runs.
- `make BUILD=/install/path/yosys`: build SystemVerilog files using custom Yosys
  binary. Default: `yosys`.
- `make PROVE=/install/path/pono`: solve SMV benchmarks using custom Pono binary.
  Default: `pono`.
- `make FP_SEMANTICS=1`: configure Pono to run with Floating-Point arithmetic
  theory instead of real arithmetic theory.
- `make TIMEOUT=10s`: specify timeout for each benchmark run. Default: `10s`.
- `make ENGINE=ind`: specify which of Pono's engines is used. Default: `ind`.
- `make SOLVER=cvc5`: specify which of Pono's SMT solvers is used. Default: `cvc5`.
- `make VERBOSITY=1`: specify Pono's verbosity. Default: `0`.
- `make BOUND=10`: specify Pono's maximum search bound. Default: `10`.
- `make WITNESS=1`: configure Pono to generate a witness trace on `sat` results.
- `make PROP=0`: solve the property of specified index. Used in benchmarks that
  have more than one assertion. Default: `0`.

# References
- Nathan Fulton, Stefan Mitsch, Jan-David Quesel, Marcus Völp, and André Platzer.
KeYmaera X: An axiomatic tactical theorem prover for hybrid systems. In Amy P.
Felty and Aart Middeldorp, editors, *CADE*, volume 9195 of *LNCS*, pages 527–538.
Springer, 2015.
- Mariam Maurice. Functional verification of analog devices modeled using SV-RNM.
In *Design and Verification Conference and Exhibition - DVCON 2024, San Jose,
CA, USA, March 4-7, 2024, Proceedings*, 2024.
- Mariam Maurice. Modeling Analog Devices using SV-RNM.
In *Design and Verification Conference and Exhibition - DVCON 2022, San Jose,
CA, USA, February 28 - March 3, 2022, Proceedings*, 2022.
- Christos Sapsanis, Martin Villemur, and Andreas G. Andreou. Real number modeling
of a SAR ADC behavior using SystemVerilog. In *2022 18th International Conference
on Synthesis, Modeling, Analysis and Simulation Methods and Applications to Circuit
Design (SMACD)*, pages 1–4, 2022.
- Olaf Zinke Kenneth S. Kundert. *The Designer’s Guide to Verilog-AMS*. Springer
New York, NY, 1st edition, 2004.
