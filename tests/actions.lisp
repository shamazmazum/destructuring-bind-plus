(defun do-all()
  (ql:quickload :destructuring-bind-plus/tests)
  (uiop:quit
   (if (uiop:symbol-call
        :destructuring-bind-plus-tests
        '#:run-tests)
       0 1)))

(do-all)
