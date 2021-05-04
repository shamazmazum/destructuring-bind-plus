DESTRUCTURING-BIND+
===================

`DESTRUCTURING-BIND+` macro is a macro similar to standard `DESTRUCTURING-BIND`
but with support for placeholder symbols which are ignored:

* `_` can be used in place of any other symbol `sym`.
* `|...|` or `…` can be used in place of `&rest sym`.

Any symbols with names `"_"` and `"..."` can be used, their package does not
matter.

Examples:
~~~~{.lisp}
DESTRUCTURING-BIND-PLUS>
 (destructuring-bind+ (a _ b …)
     '(1 2 3 4 5 6)
   (values a b))
1
3
~~~~

~~~~{.lisp}
DESTRUCTURING-BIND-PLUS>
 (destructuring-bind+ (_ a (_ b &rest c) …)
     '(1 2 ("a" "b" "c" "d") 3 4)
   (declare (type fixnum a)
            (type string b)
            (type list c))
   (values a b c))
2
"b"
("c" "d")
~~~~
