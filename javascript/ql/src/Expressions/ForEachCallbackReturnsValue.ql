/*
 * This query finds cases of calls to the array method `forEach`, which take callbacks
 * that ought to never return a value, but which are supplied with a callbacks that
 * can possibly return something.
 */

import javascript
import MethodApplicationExpr

from MethodApplicationExpr fa, FunctionRef gref, Expr ret
where
  fa.getApplicationMethodName() = "forEach" and
  fa.getAnApplicationArgument() = gref and
  gref.getReferent().getAReturnedExpr() = ret
select fa, gref, gref.getReferent(), ret
