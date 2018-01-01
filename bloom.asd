#|
  This file is a part of bloom project.
  Copyright (c) 2018 Windymelt
|#

#|
  Author: Windymelt
|#

(in-package :cl-user)
(defpackage bloom-asd
  (:use :cl :asdf))
(in-package :bloom-asd)

(defsystem bloom
  :version "0.1"
  :author "Windymelt"
  :license "BSD 3-clause"
  :depends-on (:ironclad :cl-annot)
  :components ((:module "src"
                :components
                ((:file "bloom"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op bloom-test))))
