/*
 * This little library is intended to make it easy to talk about expressions which are flowed-to.
 * That is to say, it's often nice to reason extensionally about expressions, like we normally do.
 * But the way the QL libraries set things up, we're normally always reasoning intensionally,
 * making reference mostly to syntactic objects or abstractions over them. A referring expression
 * is therefore a means to talk syntactically, but to also easilly be able to get out some
 * approximation of an extension (which in this case just means the AST object which an expression
 * ultimately refers to via dataflow. This obviously isn't really extensional for all sorts of
 * reasons, but it's close enough for the purposes.
 */

import javascript
import semmle.javascript.dataflow.DataFlow

/*
 * A `ReferringExpr` is a literal value, or a variable, or a dotted expression.
 */

class ReferringExpr extends Expr {
  ASTNode referent;

  ReferringExpr() {
    exists(DataFlow::SourceNode src | src.flowsToExpr(this) | referent = src.getAstNode())
  }

  /*
   * The referent of the expression is just the dataflow source that flows into this expression.
   */

  ASTNode getReferent() { result = referent }
}
