import javascript
import MethodApplicationExpr


from MethodApplicationExpr fa, FunctionRef gref, Expr ret
where any()
  and fa.getApplicationMethodName() = "forEach"
  and fa.getAnApplicationArgument() = gref
  and gref.getReferent().getAReturnedExpr() = ret
select fa, gref, gref.getReferent(), ret
