(in-package :cl-user)
(defpackage bloom-test
  (:use :cl
        :bloom
        :prove))
(in-package :bloom-test)

;; NOTE: To run this test file, execute `(asdf:test-system :bloom)' in your Lisp.

(plan 1)

(subtest "Bloom filter existence"
         (defparameter *bloom* (make-bloom 256))
         (ok *bloom*)
         (ok (not (bloom-member-p "hogehoge" *bloom*)))
         (ok (bloom-add "hogehoge" *bloom*))
         (ok (bloom-member-p "hogehoge" *bloom*)))

(finalize)
