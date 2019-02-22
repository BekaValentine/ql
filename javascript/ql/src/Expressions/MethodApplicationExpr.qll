import javascript

/*
 * A `FunctionRef` is an abstraction over functions to capture both function literals
 * as well as variables which refer to functions. Ideally, it should cover all
 * expressions which denote or evaluate to functions.
 */

class FunctionRef extends Expr {
  Function referent;

  FunctionRef() {
    this instanceof Function and referent = this
    or
    exists(VarUse vu, Function f | this = vu | vu.getADef().getSource() = f and referent = f)
  }

  Function getReferent() { result = referent }
}

/*
 * A `MethodApplicationExpr` is a minor abstraction over method calls which we use
 * to refer to method applications independent of whether they happen directly, via
 * `foo.bar()` syntax, or indirectly via `apply` or `call`. Because of this, the method
 * name is forbidden from being `apply` or `call`.
 */

abstract class MethodApplicationExpr extends MethodCallExpr {
  Expr argument;

  abstract string getApplicationMethodName();

  Expr getAnApplicationArgument() { result = argument }
}

/*
 * A `DirectMethodApplicationExpr` is any method application where the method is not
 * `apply` or `call` and is thus the method being applied to its arguments.
 */

class DirectMethodApplicationExpr extends MethodApplicationExpr {
  DirectMethodApplicationExpr() {
    this.getMethodName() != "apply" and
    this.getMethodName() != "call" and
    argument = this.getAnArgument()
  }

  override string getApplicationMethodName() { result = this.getMethodName() }
}

/*
 * An `ApplyMethodApplicationExpr` is a method application that happens via the method's
 * `apply` method.
 */

class ApplyMethodApplicationExpr extends MethodApplicationExpr {
  ApplyMethodApplicationExpr() {
    this.getMethodName() = "apply" and
    argument = this.getArgument(1).(ArrayExpr).getAnElement()
  }

  override string getApplicationMethodName() {
    exists(DotExpr de | de = this.getReceiver() | result = de.getPropertyName())
  }
}

/*
 * A `CallMethodApplicationExpr` is a method application that happens via the method's
 * `call` method.
 */

class CallMethodApplicationExpr extends MethodApplicationExpr {
  CallMethodApplicationExpr() {
    this.getMethodName() = "call" and
    exists(int i | i > 0 | argument = this.getArgument(i))
  }

  override string getApplicationMethodName() {
    exists(DotExpr de | de = this.getReceiver() | result = de.getPropertyName())
  }
}

/*
 * An array calback method name is just the name of those array methods which take
 * callbacks that return values (as opposed to ones that don'e return values, i.e.
 * `forEach`).
 */

predicate isArrayCallbackMethodName(string n) {
  n = "from" or
  n = "every" or
  n = "filter" or
  n = "find" or
  n = "findIndex" or
  n = "map" or
  n = "reduce" or
  n = "reduceRight" or
  n = "some" or
  n = "sort"
}
