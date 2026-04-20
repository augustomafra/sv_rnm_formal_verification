#!/bin/bash

set -euo pipefail

TIMEOUT="100s"

NJOBS="4"

VERBOSITY="1"

BOUND="999"

SOLVERS="
    cvc5
    msat
    bzla
"

ENGINES="
    bmc
    bmc-sp
    ind
    interp
    ismc
    mbic3
    ic3ia
    msat-ic3ia
"

for engine in $ENGINES
do
    for solver in $SOLVERS
    do
        if [ "${engine}" == "msat-ic3ia" ] && [ "${solver}" != "msat" ]
        then
            continue
        fi

        if [ "${solver}" != "bzla" ]
        then
            echo ">>> Running benchmark: ${solver}-${engine}"
            opts="-j${NJOBS} TIMEOUT=${TIMEOUT} ENGINE=${engine} SOLVER=${solver} BOUND=${BOUND} VERBOSITY=${VERBOSITY}"
            echo "time make prove ${opts}"
            time make prove ${opts}
            time make backup ${opts}
            echo ">>> Finished benchmark: ${solver}-${engine}"
            echo ""
        fi

        echo ">>> Running benchmark: FP-${solver}-${engine}"
        opts="-j${NJOBS} FP_SEMANTICS=1 TIMEOUT=${TIMEOUT} ENGINE=${engine} SOLVER=${solver} BOUND=${BOUND} VERBOSITY=${VERBOSITY}"
        echo "time make prove ${opts}"
        time make prove ${opts}
        time make backup ${opts}
        echo ">>> Finished benchmark: FP-${solver}-${engine}"
        echo ""
    done
done
