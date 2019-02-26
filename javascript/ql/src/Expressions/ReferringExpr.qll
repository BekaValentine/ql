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

  ASTNode getReferent() { result = referent }
}
