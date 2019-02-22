import javascript
import MethodApplicationExpr


from MethodApplicationExpr fa, FunctionRef gref
where any()
  and isArrayCallbackMethodName(fa.getApplicationMethodName())
  and fa.getAnApplicationArgument() = gref
  and not exists(gref.getReferent().getAReturnedExpr())
select fa, fa.getApplicationMethodName(), gref, gref.getReferent()
