import javascript

/*
 * A `CallbackCallExpr` is some `CallExpr` which takes a function as an argument,
 * i.e. which has a callback arg. It's useful to have such a class so that we can
 * easily refer to the callback as such.
 */

abstract class CallbackCallExpr extends CallExpr {
  abstract Function getCallback();
}

/*
 * A `MethodApplicationExpr` is a minor abstraction over method calls which we use
 * to refer to method applications independent of whether they happen directly, via
 * `foo.bar()` syntax, or indirectly via `apply` or `call`. Because of this, the method
 * name is forbidden from being `apply` or `call`.
 */

abstract class MethodApplicationExpr extends MethodCallExpr {
  abstract string getApplicationMethodName();
}

/*
 * A `DirectMethodApplicationExpr` is any method application where the method is not
 * `apply` or `call` and is thus the method being applied to its arguments.
 */

class DirectMethodApplicationExpr extends MethodApplicationExpr {
  DirectMethodApplicationExpr() {
    this.getMethodName() != "apply" and
    this.getMethodName() != "call"
  }

  override string getApplicationMethodName() { result = this.getMethodName() }
}

class DirectCallbackMethodApplicationExpr extends DirectMethodApplicationExpr, CallbackCallExpr {
  DirectCallbackMethodApplicationExpr() { this.getAnArgument() instanceof Function }

  override Function getCallback() { result = this.getAnArgument().(Function) }
}

/*
 * An `ApplyMethodApplicationExpr` is a method application that happens via the method's
 * `apply` method.
 */

class ApplyMethodApplicationExpr extends MethodApplicationExpr {
  ApplyMethodApplicationExpr() { this.getMethodName() = "apply" }

  override string getApplicationMethodName() {
    exists(DotExpr de | de = this.getReceiver() | result = de.getPropertyName())
  }
}

class CallbackApplyMethodApplicationExpr extends ApplyMethodApplicationExpr, CallbackCallExpr {
  CallbackApplyMethodApplicationExpr() {
    exists(ArrayExpr args, Function cb |
      args = this.getArgument(1) and
      cb = args.getAnElement()
    )
  }

  override Function getCallback() {
    exists(ArrayExpr args, Function cb |
      args = this.getArgument(1) and
      cb = args.getAnElement() and
      result = cb
    )
  }
}

/*
 * A `CallMethodApplicationExpr` is a method application that happens via the method's
 * `call` method.
 */

class CallMethodApplicationExpr extends MethodApplicationExpr {
  CallMethodApplicationExpr() { this.getMethodName() = "call" }

  override string getApplicationMethodName() {
    exists(DotExpr de | de = this.getReceiver() | result = de.getPropertyName())
  }
}

class CallbackCallMethodApplicationExpr extends CallMethodApplicationExpr, CallbackCallExpr {
  CallbackCallMethodApplicationExpr() { exists(Function cb | cb = this.getAnArgument()) }

  override Function getCallback() {
    exists(Function cb |
      cb = this.getAnArgument() and
      result = cb
    )
  }
}

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
