import javascript

/*
 * How can a method be invoked?
 *
 * 1. Directly: foo.method(...)
 * 2. Via the prototype: Class.prototype.method.apply(foo, [...])
 *                       Class.prototype.method.call(foo, ...)
 * 3. Other ways?
 */

/*
 * Need to do this for only things which are arrays, because other
 * types might have a forEach method that can accept returning callbacks.
 *
 * This turns out to be non-trivial.
 */

abstract class CallbackCallExpr extends CallExpr {
  abstract Function getCallback();

  Expr returnedExpr() { result = this.getCallback().getAReturnedExpr() }
}

abstract class ForEachCallExpr extends MethodCallExpr, CallbackCallExpr { }

/*
 * <something>.forEach(<callback>, ...)
 */

class ForEachMethodCallExpr extends ForEachCallExpr, CallbackCallExpr {
  ForEachMethodCallExpr() { this.getMethodName() = "forEach" }

  override Function getCallback() { result = this.getArgument(0).(Function) }
}

/*
 * <something>.forEach.apply(<something>, [<callback>, ...])
 */

class ForEachApplyCallExpr extends ForEachCallExpr, CallbackCallExpr {
  ForEachApplyCallExpr() {
    this.getMethodName() = "apply" and
    exists(DotExpr de | de = this.getReceiver() | de.getPropertyName() = "forEach")
  }

  override Function getCallback() {
    exists(ArrayExpr args, Function cb |
      args = this.getArgument(1) and
      cb = args.getElement(0) and
      result = cb
    )
  }
}

/*
 * <something>.forEach.call(<something>, <callback>, ...)
 */

class ForEachCallCallExpr extends ForEachCallExpr, CallbackCallExpr {
  ForEachCallCallExpr() {
    this.getMethodName() = "call" and
    exists(DotExpr de | de = this.getReceiver() | de.getPropertyName() = "forEach")
  }

  override Function getCallback() {
    exists(Function cb |
      cb = this.getArgument(1) and
      result = cb
    )
  }
}



from ForEachCallExpr mc
select mc, mc.returnedExpr()