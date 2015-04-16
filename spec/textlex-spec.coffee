path = require 'path'
Textlex = require '../src/textlex'

describe "Textlex", ->
  describe "when an includePath is specified", ->
    it "includes the grammar when the path is a file", ->
      textlex = new Textlex(includePath: path.join(__dirname, 'fixtures', 'includes'))
      tokens = textlex.lexSync(fileContents: 'test', scopeName: 'include1')
      expect(tokens).toEqual [ [ { value : 'test', scopes : [ 'include1' ] } ] ]

    it "includes the grammars when the path is a directory", ->
      textlex = new Textlex(includePath: path.join(__dirname, 'fixtures', 'includes', 'include1.cson'))
      tokens = textlex.lexSync(fileContents: 'test', scopeName: 'include1')
      expect(tokens).toEqual [ [ { value : 'test', scopes : [ 'include1' ] } ] ]

    it "overrides built-in grammars", ->
      textlex = new Textlex(includePath: path.join(__dirname, 'fixtures', 'includes'))
      tokens = textlex.lexSync(fileContents: 's = "test"', scopeName: 'source.coffee')
      expect(tokens).toEqual [ [ { value : 's = "test"', scopes : [ 'source.coffee' ] } ] ]

  describe "lexSync", ->
    it "returns an tokens string", ->
      textlex = new Textlex()
      tokens = textlex.lexSync(fileContents: 'test')
      expect(tokens).toEqual [ [ { value : 'test', scopes : [ 'text.plain.null-grammar' ] } ] ]

    it "uses the given scope name as the grammar to tokenize with", ->
      textlex = new Textlex()
      tokens = textlex.lexSync(fileContents: 'test', scopeName: 'source.coffee')
      expect(tokens).toEqual [ [ { value : 'test', scopes : [ 'source.coffee' ] } ] ]

    it "uses the best grammar match when no scope name is specified", ->
      textlex = new Textlex()
      tokens = textlex.lexSync(fileContents: 'test', filePath: 'test.coffee')
      expect(tokens).toEqual [ [ { value : 'test', scopes : [ 'source.coffee' ] } ] ]

  describe "requireGrammarsSync", ->
    it "loads the grammars from a file-based npm module path", ->
      textlex = new Textlex()
      textlex.requireGrammarsSync(modulePath: require.resolve('language-erlang/package.json'))
      expect(textlex.registry.grammarForScopeName('source.erlang').path).toBe path.resolve(__dirname, '..', 'node_modules', 'language-erlang', 'grammars', 'erlang.cson')

    it "loads the grammars from a folder-based npm module path", ->
      textlex = new Textlex()
      textlex.requireGrammarsSync(modulePath: path.resolve(__dirname, '..', 'node_modules', 'language-erlang'))
      expect(textlex.registry.grammarForScopeName('source.erlang').path).toBe path.resolve(__dirname, '..', 'node_modules', 'language-erlang', 'grammars', 'erlang.cson')

    it "loads default grammars prior to loading grammar from module", ->
      textlex = new Textlex()
      textlex.requireGrammarsSync(modulePath: require.resolve('language-erlang/package.json'))
      tokens = textlex.lexSync(fileContents: 'test', scopeName: 'source.coffee')
      expect(tokens).toEqual [ [ { value : 'test', scopes : [ 'source.coffee' ] } ] ]
