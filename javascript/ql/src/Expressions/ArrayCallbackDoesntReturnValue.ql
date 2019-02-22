import javascript
import MethodApplicationExpr


from MethodApplicationExpr fa, CallbackCallExpr cb
where fa = cb
  and isArrayCallbackMethodName(fa.getApplicationMethodName())
  and not exists(cb.getCallback().getAReturnedExpr())
select fa, fa.getApplicationMethodName(), cb.getCallback()
