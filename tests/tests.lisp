(in-package :destructuring-bind-plus-tests)

(def-suite destructuring-bind-plus
  :description "Test DESTRUCTURING-BIND+")

(defun run-tests ()
  (explain! (run 'destructuring-bind-plus)))

(in-suite destructuring-bind-plus)

(test simple-test
  (destructuring-bind+ (a _ b …)
      '(1 2 3 4 5 6)
    (is (= a 1))
    (is (= b 3))))

(test not-so-simple-test
  (destructuring-bind+ (_ a (_ b &rest c) …)
      '(1 2 ("a" "b" "c" "d") 3 4)
    (declare (type fixnum a)
             (type string b)
             (type list c))
    (is (= a 2))
    (is (string= b "b"))
    (is (equalp c '("c" "d")))))

(defun get-numbers (n)
  (loop repeat n collect 1))

(test wrong-pattern
  (signals error
   (destructuring-bind+ (a b)
       (get-numbers 3)
     (values a b))))
