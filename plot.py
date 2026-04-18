import glob
import os
import re

MAKEFILES = [
    "tests/capacitor/Makefile",
    "tests/designers_guide/ch4/Makefile",
    "tests/designers_guide/ch4/listing09/Makefile.prop0",
    "tests/designers_guide/ch4/listing09/Makefile.prop1",
    "tests/designers_guide/ch4/listing12/Makefile",
    "tests/flop_rnm/Makefile",
    "tests/keymaera_x/damped_oscillator/Makefile",
    "tests/keymaera_x/event_triggered_ping_pong_ball/Makefile",
    "tests/keymaera_x/event_triggered_ping_pong_ball/Makefile.with_invariant",
    "tests/keymaera_x/forward_driving_car/Makefile",
    "tests/keymaera_x/short_bouncing_ball/Makefile",
    "tests/keymaera_x/short_bouncing_ball/Makefile.with_invariant",
    "tests/maurice2024/Makefile.adc_dac",
    "tests/maurice2024/Makefile.dac_adc",
    "tests/maurice2024/Makefile.maurice2024_adc",
    "tests/maurice2024/Makefile.maurice2024_dac",
    "tests/rnm_example/Makefile"
]

SOLVERS = [
    "cvc5",
    "msat",
    "bzla"
]

ENGINES = [
    "bmc",
    "bmc-sp",
    "ind",
    "interp",
    "ismc",
    "mbic3",
    "ic3ia",
    "msat-ic3ia"
]

SAT = "sat\n"
UNSAT = "unsat\n"
UNKNOWN = "unknown\n"
ERROR = "error\n"
bound_re = re.compile(r"BMC check at bound (\d+) unsatisfiable")
time_re = re.compile(r"Pono wall clock time \(s\): ([\d.]+)")
core_re = re.compile(r"dumped core")

class Result:
    def __init__(self, path, solver, engine, is_floating_point):
        self.path = path
        self.solver = solver
        self.engine = engine
        self.is_floating_point = is_floating_point
        self.result = "unknown\n"
        self.bound = 0
        self.time = 100.0

    def __repr__(self):
        theory = "fp" if self.is_floating_point else "ra"
        result = self.result[:-1]
        bound = f"{self.bound}" if self.result != UNSAT else ""
        return f"{result},{bound},{self.solver},{self.engine},{theory},{self.time},{self.path}\n"

results = dict()

for makefile in MAKEFILES:
    dirname = os.path.dirname(makefile)
    extension_with_dot = os.path.splitext(makefile)[1]
    extension = extension_with_dot[1:]
    logs = glob.glob(f"{dirname}/*{extension}_*.log")
    if not logs:
        print(f"warning: no log found for {dirname}/*{extension}_*.log")

    for log in logs:
        basename = os.path.basename(log)
        name = os.path.splitext(basename)[0]
        parsed_name = name.split("_")
        fp, engine, solver = parsed_name[-3:]
        is_floating_point = fp == "fp"
        test_name = "_".join(parsed_name[:-3]) + "_fp" if is_floating_point else "_".join(parsed_name[:-2])

        if extension != "with_invariant" and "with_invariant" in test_name:
            continue

        result = Result(log, solver, engine, is_floating_point)
        if not test_name in results:
            results[test_name] = list()

        results[test_name].append(result)

        with open(log, "r") as logfile:
            for line in logfile:
                if line == SAT:
                    result.result = SAT
                elif line == UNSAT:
                    result.result = UNSAT
                elif line == ERROR:
                    result.result = ERROR
                elif match := bound_re.search(line):
                    result.bound = int(match.group(1))
                elif match := time_re.search(line):
                    result.time = float(match.group(1))
                elif match := core_re.search(line):
                    result.result = ERROR

best_results = dict()
for test, result_list in results.items():
    best_result = None
    for result in result_list:
        if result.result == SAT:
            if best_result and best_result.result == UNSAT:
                print(f"warning: conflicting results found for {test}")
            if not best_result or result.time < best_result.time:
                best_result = result
        elif result.result == UNSAT:
            if best_result and best_result == SAT:
                print(f"warning: conflicting results found for {test}")
            if not best_result or result.time < best_result.time:
                best_result = result
        elif result.result == UNKNOWN:
            if not best_result or ( \
                best_result.result != SAT \
                    and best_result.result != UNSAT \
                    and result.bound > best_result.bound):
                    best_result = result

    assert(best_result)
    best_results[test] = best_result

for test, result in best_results.items():
    print(f"{test},{result}", end='')
