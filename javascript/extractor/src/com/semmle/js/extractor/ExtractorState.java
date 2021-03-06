package com.semmle.js.extractor;

import com.semmle.js.parser.TypeScriptParser;

/**
 * Contains the state to be shared between extractions of different files.
 *
 * <p>In general, this contains both semantic state that affects the extractor output as well as
 * shared resources that are simply expensive to reacquire.
 *
 * <p>The {@link #reset()} method resets the semantic state while retaining shared resources when
 * possible.
 *
 * <p>Concretely, the shared resource is the Node.js process running the TypeScript compiler, which
 * is expensive to restart. The semantic state is the set of projects currently open in that
 * process, which affects the type information obtained during extraction of a file.
 */
public class ExtractorState {
  private TypeScriptParser typeScriptParser = new TypeScriptParser();

  public TypeScriptParser getTypeScriptParser() {
    return typeScriptParser;
  }

  /**
   * Makes this semantically equivalent to a fresh state, but may internally retain shared resources
   * that are expensive to reacquire.
   */
  public void reset() {
    typeScriptParser.reset();
  }
}
