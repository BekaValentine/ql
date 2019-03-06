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

ConcreteControlFlowNode getAnUndefinedReturn(Function f) {
  not (f instanceof ArrowFunctionExpr and f.getBody() instanceof Expr) and
  result.getContainer() = f and
  result.isAFinalNode()  and
  not (result instanceof ReturnStmt and exists(result.(ReturnStmt).getExpr())) and
  not result instanceof ThrowStmt
}
