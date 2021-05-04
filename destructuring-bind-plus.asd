(defsystem :destructuring-bind-plus
  :name :destructuring-bind-plus
  :version "1.0"
  :author "Vasily Postnicov <shamaz.mazum@gmail.com>"
  :description "DESTRUCTURING-BIND* with placeholders"
  :license "2-clause BSD"
  :pathname "src/"
  :components ((:file "package")
               (:file "destructuring-bind-plus" :depends-on ("package")))
  :in-order-to ((test-op (load-op "destructuring-bind-plus/tests")))
  :perform (test-op (op system)
                    (declare (ignore op system))
                    (uiop:symbol-call :destructuring-bind-plus-tests '#:run-tests)))

(defsystem :destructuring-bind-plus/tests
  :name :destructuring-bind-plus/tests
  :version "1.0"
  :author "Vasily Postnicov <shamaz.mazum@gmail.com>"
  :license "2-clause BSD"
  :pathname "tests/"
  :components ((:file "package")
               (:file "tests" :depends-on ("package")))
  :depends-on (:destructuring-bind-plus :fiveam))
