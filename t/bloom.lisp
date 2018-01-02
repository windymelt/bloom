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

(subtest "Bloom-subset-p"
         (defparameter *bloom-hoge* (make-bloom 256))
         (defparameter *bloom-hoge-huga* (make-bloom 256))
         (ok (bloom-add "hoge" *bloom-hoge*) "Can add hoge into *bloom-hoge*")
         (ok (bloom-add "hoge" *bloom-hoge-huga*) "Can add hoge into *bloom-hoge-huga*")
         (ok (bloom-add "huga" *bloom-hoge-huga*) "Can add huga into *bloom-hoge-huga*")
         (ok (bloom-member-p "hoge" *bloom-hoge*) "hoge should be member of *bloom-hoge*")
         (ok (bloom-member-p "hoge" *bloom-hoge-huga*) "hoge should be member of *bloom-hoge-huga*")
         (ok (bloom-member-p "huga" *bloom-hoge-huga*) "huga should be member of *bloom-hoge-huga*")
         (ok (bloom-subset-p *bloom-hoge* *bloom-hoge-huga*) "*bloom-hoge* should be subset of *bloom-hoge-huga*")
         (ok (bloom-subset-p *bloom-hoge* *bloom-hoge*) "*bloom-hoge* should be subset of *bloom-hoge*")
         (ok (bloom-subset-p *bloom-hoge-huga* *bloom-hoge-huga*) "*bloom-hoge-huga* should be subset of *bloom-hoge-huga*")
         (ok (not (bloom-subset-p *bloom-hoge-huga* *bloom-hoge*)) "*bloom-hoge-huga* should not be subset of *bloom-hoge*"))

(finalize)
