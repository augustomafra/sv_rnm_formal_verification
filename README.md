[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19168740.svg)](https://doi.org/10.5281/zenodo.19168740)

# Usage
- Install forks of [Yosys](https://github.com/augustomafra/yosys/tree/real_number_formal_modeling) and [Pono](https://github.com/augustomafra/pono/tree/smv_fp_only).
- Run `make` to automatically build and run all benchmarks.
## Details
- `make build`: only build benchmarks.
- `make prove | all`: build and run all benchmarks. It is the default target.
- `make backup`: save a `.log.bak` backup file for the current benchmark settings.
- `make clean`: deletes built artifacts. Note: Does not remove `.log` files
  generated from benchmark runs.
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
