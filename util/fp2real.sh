#!/bin/bash

while IFS= read -r line
do
    fp_values=$(grep -o '(fp ([^)]*) ([^)]*) ([^)]*))\|(fp #b[01]* #b[01]* #b[01]*)' <<< ${line})

    converted_to_real=""
    while IFS= read -r fp_value
    do
        if [ ! -z "${fp_value}" ]
        then
            smt_lib_script="
                (set-logic QF_FPNRA)
                (set-option :produce-models true)

                (declare-const fp_val Float64)
                (declare-const as_real Real)
                (declare-const is_subnormal Bool)
                (declare-const is_infinite Bool)
                (declare-const is_nan Bool)

                (assert (= fp_val ${fp_value}))
                (assert (= as_real (fp.to_real fp_val)))
                (assert (= is_subnormal (fp.isSubnormal fp_val)))
                (assert (= is_infinite (fp.isInfinite fp_val)))
                (assert (= is_nan (fp.isNaN fp_val)))                

                (check-sat)
                (get-value (as_real))
                (get-value (is_subnormal))
                (get-value (is_infinite))
                (get-value (is_nan))                
            "

            tmpfile=`mktemp`
            echo "${smt_lib_script}" > "${tmpfile}"
            out=$(cvc5 "${tmpfile}")

            is_nan=$(grep 'is_nan true' <<< "${out}")
            if [ ! -z "${is_nan}" ]
            then
                sed "s~\((fp ([^)]*) ([^)]*) ([^)]*))\|(fp #b[01]* #b[01]* #b[01]*)\)~\1 ((as_real NaN))~g" <<< "${line}"
                converted_to_real="${is_nan}"
            else
                is_infinite=$(grep 'is_infinite true' <<< "${out}")
                if [ ! -z "${is_infinite}" ]
                then
                    sed "s~\((fp ([^)]*) ([^)]*) ([^)]*))\|(fp #b[01]* #b[01]* #b[01]*)\)~\1 ((as_real Inf))~g" <<< "${line}"
                    converted_to_real="${is_infinite}"
                else
                    as_real=$(grep 'as_real' <<< "${out}")
                    is_subnormal=$(grep 'is_subnormal true' <<< "${out}")
                    if [ ! -z "${as_real}" ]
                    then
                        sed "s~\((fp ([^)]*) ([^)]*) ([^)]*))\|(fp #b[01]* #b[01]* #b[01]*)\)~\1 ${as_real} ${is_subnormal}~g" <<< "${line}"
                        converted_to_real="${as_real}"
                    fi                  
                fi          
            fi
        fi
    done <<< "${fp_values}"

    if [ -z "${converted_to_real}" ]
    then
        echo "${line}"
    fi
done
