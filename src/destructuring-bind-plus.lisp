(in-package :destructuring-bind-plus)

(defstruct placeholder-bag
  (placeholders nil :type list))

(defun placeholder (placeholder-bag)
  (declare (type placeholder-bag placeholder-bag))
  (let ((placeholder (gensym)))
    (push placeholder (placeholder-bag-placeholders placeholder-bag))
    placeholder))

(defun scan-for-placeholders (bindings &optional (placeholders (make-placeholder-bag)))
  (flet ((reduce-bindings (binding acc)
           (declare (type (or list symbol) binding))
           (cond
             ((listp binding)
              (cons (scan-for-placeholders binding placeholders) acc))
             ((string= (symbol-name binding) "_")
              (cons (placeholder placeholders) acc))
             ((or (string= (symbol-name binding) "...")
                  (string= (symbol-name binding) "…"))
              (append (list 'cl:&rest (placeholder placeholders))
                      acc))
             (t (cons binding acc)))))
    (values
     (reduce #'reduce-bindings bindings
             :from-end      t
             :initial-value nil)
     (placeholder-bag-placeholders placeholders))))

(defun add-declarations (ignored-variables body)
  (declare (type list ignored-variables body))
  (let ((declarations
          (loop for var in ignored-variables
                collect `(ignore ,var))))
    (if declarations
        (destructuring-bind (expr . exprs) body
          (cond
            ((and (listp expr)
                  (eq (car expr) 'cl:declare))
             `((declare ,@(cdr expr) ,@declarations)
               ,@exprs))
            (t
             `((declare ,@declarations)
               ,@body))))
        body)))

(defmacro destructuring-bind+ (bindings expression &body body)
  "This macro is like DESTRUCTURING-BIND* but allows the following
placeholder symbols, which are ignored:

* `_` is a placeholder for a symbol
* `…` or `|...|` is a placeholder for `&rest symbol`"
  (multiple-value-bind (bindings placeholders)
      (scan-for-placeholders bindings)
    (let ((body-with-declarations
            (add-declarations placeholders body)))
      `(destructuring-bind ,bindings ,expression
         ,@body-with-declarations))))
