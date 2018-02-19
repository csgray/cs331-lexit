-- lexit.lua
-- Corey Gray
-- 18 February 2018
-- Source for lexit module for CS 331: Assignment 3B

local lexit = {}

-- ***
-- Public Constant
-- ***

-- Numeric constants representing lexeme categories
lexit.KEY = 1
lexit.ID = 2
lexit.NUMLIT = 3
lexit.STRLIT = 4
lexit.OP = 5
lexit.PUNCT = 6
lexit.MAL = 7

-- catnames
-- Array of names of lexeme categories.
-- Human-readable strings. Indices are above numeric constants.
lexit.catnames = {
  "Keyword",
  "Identifier",
  "NumericLiteral",
  "StringLiteral",
  "Operator",
  "Punctuation",
  "Malformed"
  }

-- ***
-- The Lexer
-- ***

-- preferOp
-- Takes no parameters and returns nothing.
-- If this function is called just before a loop iteration, then, on that iteration, the lexer prefers to return an operator, rather than a number.
function lexit.preferOp()
  end

-- lex
-- Takes a string parameter and allows for for-in iteration
-- through lexemes in the passed string
function lexit.lex(program)
  end