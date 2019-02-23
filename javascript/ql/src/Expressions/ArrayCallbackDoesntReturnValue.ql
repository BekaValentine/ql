/*
 * This query finds cases of calls to array methods which take callbacks that ought to
 * return a value, such as `map` or `filter`, but which are supplied with callbacks that
 * can possible return nothing at all.
 *
 * LIMITATION: This query only looks at explicit returns; it does not look for cases
 * where the callback has an execution path that doesn't return a value due to the total
 * absence of return statements.
 */

import javascript
import MethodApplicationExpr

from MethodApplicationExpr fa, FunctionRef gref
where
  isArrayCallbackMethodName(fa.getApplicationMethodName()) and
  fa.getAnApplicationArgument() = gref and
  exists(ReturnStmt retstmt | retstmt = gref.getReferent().getAReturnStmt() |
    not exists(retstmt.getExpr())
  )
select fa, fa.getApplicationMethodName(), gref, gref.getReferent()
