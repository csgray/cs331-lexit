-- lexit.lua
-- Corey Gray
-- 18 February 2018
-- Source for lexit module for CS 331: Assignment 3B
-- Heavily based on "lexer.lua" by Glenn G. Chappell

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

-- ****
-- Variables
-- ****

-- Indicates that the next lexeme, if it begins with + or -, should always be interpreted as an operator.
local preferOpFlag = false;

-- ****
-- Kind-of-Character Functions
-- ****

-- isLetter
-- Returns true if string is a letter character, false otherwise.
local function isLetter(character)
  if character:len() ~= 1 then
    return false
  elseif character >= "A" and character <= "Z" then
    return true
  elseif character >= "a" and character <= "z" then
    return true
  else
    return false
  end
end

-- isDigit
-- Returns true if string character is a digit character, else otherwise.
local function isDigit(character)
  if character:len() ~= 1 then
    return false
  elseif character >= "0" and character <= "9" then
    return true
  else
    return false
  end
end

-- isWhitespace
-- Returns true if string character is a whitespace character, false otherwise.
local function isWhitespace(character)
  if character:len() ~= 1 then
    return false
  elseif character == " " or
         character == "\t" or
         character == "\v" or
         character == "\n" or
         character == "\r" or
         character == "\f" then
    return true
  else
    return false
  end
end

-- isIllegal
-- Returns true if string character is an illegal character, false otherwise
local function isIllegal(character)
  if character:len() ~= 1 then
    return false
  elseif isWhitespace(character) then
    return false
  elseif character >= " " and character <= "~" then
    return false
  else
    return true
  end
end

-- ***
-- The Lexer
-- ***

-- preferOp
-- Takes no parameters and returns nothing.
-- If this function is called just before a loop iteration, then, on that iteration, the lexer prefers to return an operator, rather than a number.
function lexit.preferOp()
  preferOpFlag = true;
end

-- lex
-- Takes a string parameter and allows for for-in iteration
-- through lexemes in the passed string
function lexit.lex(program)
  
  -- **** Variables
  local position 
  local state
  local character
  local lexeme
  local category
  local handlers
  
  -- **** States
  local DONE = 0
  local START = 1
  local LETTER = 2
  local DIGIT = 3
  local DIGDOT = 4
  local PLUS = 5
  local MINUS = 6
  local STAR = 7
  local DOT = 8
  
  -- **** Character-Related Utility Functions
  
  -- currentCharacter
  -- Returns the current character at index position in program.
  -- Return value is a single-character string or the empty string if position is past the end.
  local function currentCharacter()
    return program:sub(position, position)
  end
  
  -- nextCharacter
  -- Return the next character at index position+1 in program.
  -- Return value is a single-character string or the empty string if position is past the end.
  local function nextCharacter()
    return program:sub(position+1, position+1)
  end
  
  -- drop1
  -- Move position to the next character.
  local function drop1()
    position = position+1
  end
  
  -- add1
  -- Add the current character to the lexeme, moving position to the next character.
  local function add1()
    lexeme = lexeme .. currentCharacter()
    drop1()
  end
  
  -- skipWhitespace
  -- Skip whitespace and comments by moving position to the beginning of the next lexeme or to program:len()+1.
  local function skipWhitespace()
    while true do
      while isWhitespace(currentCharacter()) do
        drop1()
      end
      
      if currentCharacter() ~= "#" then
        while true do
          if currentCharacter() == "\n" then
            break
          elseif currentCharacter() == "" then
            return
          end
          drop1()
        end
      end
    end
  end
  
  -- **** State-Handler Functions
  local function handle_DONE()
    io.write("ERROR: 'DONE' state should not be handled.\n")
    assert(0)
  end
  

    -- **** Table of State-Handler Functions

    handlers = {
        [DONE]=handle_DONE,
        [START]=handle_START,
    }
  
  -- **** Iterator Function
  -- getLexeme
  -- Called each time through the for-in loop.
  -- Returns a pair: lexeme (string), category (int) or nil, nil if no more lexeme.
  local function getLexeme(dummy1, dummy2)
    if position > program:len() then
      preferOpFlag = false
      return nil, nil
    end
    
    lexeme  = ""
    state = START
    while state ~= DONE do
      character = currentCharacter()
      handlers[state]()
    end
    
    skipWhitespace()
    preferOpFlag = false
    return lexeme, category
  end
  
  -- **** Body of Function Lexit
  -- Initialize and return the iterator function
  position = 1
  skipWhitespace()
  return getLexeme, nil, nil
end
  
-- ****
-- Module Table Return
-- ****

return lexit
