/*
 * This query finds cases of calls to array methods which take callbacks that ought to
 * return a value, such as `map` or `filter`, but which are supplied with callbacks that
 * can possible return nothing at all.
 */

import javascript
import FunctionUtils
import ReferringExpr

from MethodApplicationExpr fa, ReferringExpr gref, Function f
where
  isArrayCallbackMethodName(fa.getApplicationMethodName()) and
  fa.getAnApplicationArgument() = gref and
  gref.getReferent() = f and
  canReturnNothing(f)
select fa, fa.getApplicationMethodName(), gref, f
