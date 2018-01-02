(in-package :cl-user)
(defpackage bloom
  (:use :cl :cl-annot)
  (:import-from :ironclad
   :digest-sequence :integer-to-octets :octets-to-integer))
(in-package :bloom)

(annot:enable-annot-syntax)

;;; Count of hash masking per adding to filter
@export
(defparameter *k* 3)

@export
(defun make-bloom (m)
  "Return new bloom filter."
  (make-array m :element-type 'bit))

@inline
(defun item-hash (it)
  "Calculate hash of item. Hash is divided to two parts to calc double-hash."
  (let ((hash (digest-sequence :adler32 (integer-to-octets (sxhash it)))))
    (values (subseq hash 0 2) (subseq hash 2)))) ; 2 bytes = 16 bits

@inline
(defun nth-hash (n hasha hashb filter-size)
  "Calculate composed hash with double-hash method."
  (mod (+ (octets-to-integer hasha) (* n (octets-to-integer hashb))) filter-size))

@export
(defun bloom-add (obj bloom)
  "Add OBJ into BLOOM filter. Destructive function."
  (multiple-value-bind (hasha hashb) (item-hash obj)
    (let ((len (length bloom)))
      (loop for n from 0 below *k*
            do (setf (elt bloom (nth-hash n hasha hashb len)) 1))
      t)))

@export
@inline
(defun bloom-member-p (obj bloom)
  "Conisder whether OBJ belongs to BLOOM filter."
  (multiple-value-bind (hasha hashb) (item-hash obj)
    (let ((len (length bloom)))
      (loop for n from 0 below *k*
            always (eq (elt bloom (nth-hash n hasha hashb len)) 1)))))

@export
(defun bloom-subset-p (subset-like parent)
  "Consider whether SUBSET-LIKE is subset of PARENT."
  (equal parent (bit-ior subset-like parent)))

@export
(defun bloom-clr (bloom)
  "Clear BLOOM filter. Destructive function."
  (loop for n from 0 below (length bloom)
        do (setf (elt bloom n) 0)))
