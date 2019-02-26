/*
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

from
     MethodApplicationExpr application
   , ReferringExpr callbackRef
   , Function callback
where
      isArrayCallbackMethodName(application.getApplicationMethodName())
  and application.getAnApplicationArgument() = callbackRef
  and callbackRef.getReferent() = callback
  and canReturnNothing(callback)
select
       application
     , application.getApplicationMethodName()
     , callbackRef
     , callback
