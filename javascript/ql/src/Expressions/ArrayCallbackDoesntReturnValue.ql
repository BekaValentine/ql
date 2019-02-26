/*
 * This query finds cases of calls to array methods which take callbacks that ought to
 * return a value, such as `map` or `filter`, but which are supplied with callbacks that
 * can possible return nothing at all.
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
