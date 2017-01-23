'use strict'

path = require 'path'
_ = require 'underscore-plus'
fs = require 'fs-plus'
CSON = require 'season'
pickGrammar = require('first-mate-select-grammar')()
{GrammarRegistry} = require 'first-mate'

module.exports =
class Textlex
  # Public: Create a new text lexer.
  #
  # options - An Object with the following keys:
  #   :includePath - An optional String path to a file or folder of grammars to
  #                  register.
  #   :registry    - An optional GrammarRegistry instance.
  constructor: ({@includePath, @registry}={}) ->
    @registry ?= new GrammarRegistry maxTokensPerLine: Infinity

  loadGrammarsSync: ->
    return if @registry.grammars.length > 1

    if typeof @includePath is 'string'
      if fs.isFileSync @includePath
        @registry.loadGrammarSync @includePath
      else if fs.isDirectorySync @includePath
        for filePath in fs.listSync @includePath, ['cson', 'json']
          @registry.loadGrammarSync filePath

    grammarsPath = path.join __dirname, '..', 'gen', 'grammars.json'
    for grammarPath, grammar of JSON.parse fs.readFileSync grammarsPath
      continue if @registry.grammarForScopeName(grammar.scopeName)?
      grammar = @registry.createGrammar grammarPath, grammar
      @registry.addGrammar grammar

  # Public: Require all the grammars from the grammars folder at the root of an
  #   npm module.
  #
  # modulePath - the String path to the module to require grammars from. If the
  #              given path is a file then the grammars folder from the parent
  #              directory will be used.
  requireGrammarsSync: ({modulePath}={}) ->
    @loadGrammarsSync()

    if fs.isFileSync modulePath
      packageDir = path.dirname modulePath
    else
      packageDir = modulePath

    grammarsDir = path.resolve packageDir, 'grammars'

    return unless fs.isDirectorySync grammarsDir

    for file in fs.readdirSync grammarsDir
      if grammarPath = CSON.resolve path.join grammarsDir, file
        @registry.loadGrammarSync grammarPath

  # Public: Lex the given file synchronously.
  #
  # options - An Object with the following keys:
  #   :fileContents - The optional String contents of the file. The file will
  #                   be read from disk if this is unspecified
  #   :filePath     - The String path to the file.
  #   :scopeName    - An optional String scope name of a grammar. The best match
  #                   grammar will be used if this is unspecified.
  #
  # Returns a String of HTML.
  lexSync: ({filePath, fileContents, scopeName}={}) ->
    @loadGrammarsSync()

    fileContents ?= fs.readFileSync(filePath, 'utf8') if filePath
    grammar = @registry.grammarForScopeName scopeName
    grammar ?= pickGrammar.selectGrammar @registry, filePath, fileContents
    lineTokens = grammar.tokenizeLines fileContents

    # Remove trailing newline
    if lineTokens.length > 0
      lastLineTokens = lineTokens[lineTokens.length - 1]
      if lastLineTokens.length is 1 and lastLineTokens[0].value is ''
        lineTokens.pop()

    lineTokens
