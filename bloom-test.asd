#|
  This file is a part of bloom project.
  Copyright (c) 2018 Windymelt
|#

(in-package :cl-user)
(defpackage bloom-test-asd
  (:use :cl :asdf))
(in-package :bloom-test-asd)

(defsystem bloom-test
  :author "Windymelt"
  :license ""
  :depends-on (:bloom
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "bloom"))))
  :description "Test system for bloom"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
