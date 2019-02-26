/*
 * This query finds cases where a function doesn't necessarily return a value, but is called in
 * a context where its expect to do so, such as an assignment or an addition expression.
 */

import javascript
import FunctionUtils
import ReferringExpr
import semmle.javascript.CFG

/*
 * A function with no return value can be called in a variety of places without it being bad.
 * Amongst them are...
 *
 * - As a statement, b/c the function is used for its side effects only
 * - When the function is completely empty and has no statements in it
 * - When the function is in an error function (TODO)
 * - In an immediately invoked function expression (IIFE)
 * - When the application is immediately returned
 * - When the application is in a void expression
 */

predicate isValidCallOfNoReturnFunction(CallExpr call, Function f) {
  isInExprStmt(call)
  or
  isEmpty(f)
  or
  isErrorFunction(f)
  or
  isIife(call)
  or
  isInReturnExpr(call)
  or
  isInVoidExpr(call)
}

predicate isEmpty(Function f) { 0 = f.getNumBodyStmt() }

predicate isErrorFunction(Function f) { none() }

predicate isInExprStmt(CallExpr call) { call.getParent() instanceof ExprStmt }

predicate isIife(CallExpr call) { call.getCallee().stripParens() instanceof Function }

predicate isInReturnExpr(Expr call) { call.getParent() instanceof ReturnStmt }

predicate isInVoidExpr(Expr call) { call.getParent() instanceof VoidExpr }

from
     CallExpr call
   , ReferringExpr calleeRef
   , Function callee
where
      call.getCallee() = calleeRef
  and calleeRef.getReferent() = callee
  and canReturnNothing(callee)
  and not isValidCallOfNoReturnFunction(call, callee)
select
       call
     , calleeRef
     , callee
     , callee.getBody()
