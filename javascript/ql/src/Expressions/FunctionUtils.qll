/**
 * This library provides tools for referencing functions in various ways related more
 * to the logical concept of a function rather than the syntactic one. For example,
 * variables which are bound to functions ought to behave the same as the function
 * itself, so it would be useful to have a mechanism by which one can describe all
 * expressions which refer to a function, whether its function literals or variables
 * bound to functions, as if they're the same thing.
 */

import javascript
import semmle.javascript.CFG

/**
 * A return of nothing is an expression or statement in the body of a function, which
 * can be executed last, and which does not result in a value being returned.
 * 
 * If the body of an arrow function expression is itself an expression, then the
 * function has no returns of nothing, so we must only consider cases other tha this.
 * 
 * For every other kind of function, we need an explicit return statement with an
 * expression argument in order to return a value. So any node which is last to execute
 * which is NOT a return with an expression must be a return of nothing.
 */

ConcreteControlFlowNode getAReturnOfNothing(Function f) {
  not (f instanceof ArrowFunctionExpr and f.getBody() instanceof Expr)
  and
  exists(ConcreteControlFlowNode final | final.getContainer() = f and final.isAFinalNode() |
    (
      not (final instanceof ReturnStmt and exists(final.(ReturnStmt).getExpr()))
    ) and
    result = final
  )
}

/**
 * A function can return nothing if it's a function expression with an empty return, or
 * a non-return final expression, or alternatively if its an arrow function with an empty
 * return.
 */

predicate canReturnNothing(Function f) { exists(getAReturnOfNothing(f)) }

/**
 * A `MethodApplicationExpr` is a minor abstraction over method calls which we use
 * to refer to method applications independent of whether they happen directly, via
 * `foo.bar()` syntax, or indirectly via `apply` or `call`. Because of this, the method
 * name is forbidden from being `apply` or `call`.
 */

abstract class MethodApplicationExpr extends MethodCallExpr {
  Expr argument;

  /**
   * The application method name is just the name of the method being applied, once we
   * look at it through this lens of abstraction. So for example, in `foo.bar()`,
   * `C.prototype.bar.apply(foo, [])`, and `C.prototype.bar.call(foo)`, the application
   * method name is `bar`.
   */

  abstract string getApplicationMethodName();

  /**
   * The application arguments are just the arguments of the method, once we look at
   * them through this lens of abstraction. So for example, in `foo.bar(x,y,z)`,
   * `C.prototype.bar.apply(foo, [x,y,z])`, and `C.prototype.bar.call(foo, x, y, z)`,
   * the application arguments are `x`, `y`, and `z`.
   */

  Expr getAnApplicationArgument() { result = argument }
}

/**
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

/**
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

/**
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

/**
 * An array callback method name is just the name of those array methods which take
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
