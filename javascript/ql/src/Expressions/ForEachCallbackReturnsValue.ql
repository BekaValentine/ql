import javascript
import MethodApplicationExpr


from MethodApplicationExpr fa, CallbackCallExpr cb
where
  fa.getApplicationMethodName() = "forEach" and
  fa = cb
select fa, cb.getCallback().getAReturnedExpr()
