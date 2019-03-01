/**
 * @name ForEach Callback Returns Value
 * @description The `forEach` method's callback should not return a value because `forEach`
 *              discards them.
 * @kind problem
 * @problem.severity warning
 * @id js/foreach-callback-returns-value
 * @precision very-high
 * @tag correctness
 */

import javascript
import FunctionUtils
import ReferringExpr

/*
 * We have a problem when there is an application `application` that calls
 * the `forEach` method, and is given a callback argument `callbackRef`,
 * which refers to the callback function `callback`, which can return the
 * expression `returnVal`.
 */

from
     MethodApplicationExpr application
   , ReferringExpr callbackRef
   , Function callback
   , Expr returnVal
where
      not application.getTopLevel().isMinified()
  and application.getApplicationMethodName() = "forEach"
  and application.getAnApplicationArgument() = callbackRef
  and callbackRef.getReferent() = callback
  and callback.getAReturnedExpr() = returnVal
select
       application
     , "This method application has the callback argument $@, which is expected to not return any values, but its definitions is $@, which returns the value $@"
     , callbackRef, callbackRef.toString()
     , callback, callback.toString()
     , returnVal, returnVal.toString()
