/**
 * @name Array Callback Doesn't Return Value
 * @description Array callbacks like `map` and `filter` expect a value to be returned, so code
 *              should never omit a return value in any execution path.
 * @kind problem
 * @problem.severity warning
 * @id js/array-callback-doesnt-return-value
 * @precision very-high
 * @tag correctness
 */

import javascript
import FunctionUtils
import ReferringExpr

/*
 * We have a problem when there is a method application `application`, which
 * is given a callback argument `callbackRef`, which refers to the callback
 * function `callback` that can return nothing via the control flow node
 * `returnOfNothing`.
 */

from
     MethodApplicationExpr application
   , ReferringExpr callbackRef
   , Function callback
   , ConcreteControlFlowNode returnOfNothing
where
      not application.getTopLevel().isMinified()
  and isArrayCallbackMethodName(application.getApplicationMethodName())
  and application.getAnApplicationArgument() = callbackRef
  and callbackRef.getReferent() = callback
  and returnOfNothing = getAReturnOfNothing(callback)
select
       application
     , "This method application calls the method `" + application.getApplicationMethodName() + "` which expects its callback to return a value, and has the callback argument $@, which is defined as $@, but this definition can return nothing by executing this last: $@"
     , callbackRef, callbackRef.toString()
     , callback, callback.toString()
     , returnOfNothing, returnOfNothing.toString()