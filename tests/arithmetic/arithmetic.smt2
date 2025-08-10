(set-logic UFNRAT)
(set-option :produce-models true)

(declare-const x Real)
(declare-const y Real)
(declare-fun uninterpreted_exp (Real) Real)

(assert (forall ((a Real) (b Real)) (=> (= (uninterpreted_exp a) (uninterpreted_exp b)) (= a b))))

(assert (= y (uninterpreted_exp x)))
(assert (= y (uninterpreted_exp 2)))
(assert (distinct x 2))

(check-sat)
(get-value (x))
(get-value (y))
