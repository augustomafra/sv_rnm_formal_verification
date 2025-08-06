(set-logic QF_FPNRA)
(set-option :produce-models true)

(declare-const fp_val Float64)
(declare-const as_real Real)
(declare-const is_normal Bool)
(declare-const is_subnormal Bool)
(declare-const is_infinite Bool)
(declare-const is_nan Bool)

(assert (= fp_val (fp (_ bv0 1) (_ bv2047 11) (_ bv2251799813685248 52))))
(assert (= as_real (fp.to_real fp_val)))
(assert (= is_normal (fp.isNormal fp_val)))
(assert (= is_subnormal (fp.isSubnormal fp_val)))
(assert (= is_infinite (fp.isInfinite fp_val)))
(assert (= is_nan (fp.isNaN fp_val)))

(check-sat)
(get-value (as_real))
(get-value (is_normal))
(get-value (is_subnormal))
(get-value (is_infinite))
(get-value (is_nan))

