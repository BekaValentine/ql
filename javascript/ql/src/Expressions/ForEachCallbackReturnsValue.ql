/*
 * This query finds cases of calls to the array method `forEach`, which take callbacks
 * that ought to never return a value, but which are supplied with a callbacks that
 * can possibly return something.
 */

import javascript
import FunctionUtils
import ReferringExpr

from
     MethodApplicationExpr application
   , ReferringExpr callbackRef
   , Function callback
   , Expr returnVal
where
      application.getApplicationMethodName() = "forEach"
  and application.getAnApplicationArgument() = callbackRef
  and callbackRef.getReferent() = callback
  and callback.getAReturnedExpr() = returnVal
select
       application
     , callbackRef
     , callback
     , returnVal
