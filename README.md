A lexical analyser using TextMate-style grammars: reads in code, returns an array of tokens for each line.

Based on [Highlights](https://github.com/atom/highlights).

[![Build Status](https://travis-ci.org/jonruttan/textlex.svg)](https://travis-ci.org/jonruttan/textlex)

### Installing

```sh
npm install textlex
```

### Using

To convert a source file to tokens use the following code:

```coffee
textlex = require 'textlex'
textlexer = new textlex()
linetokens = textlexer.lexSync
  fileContents: "var hello = 'world';\nconsole.log('Hello, ' + hello);"
  scopeName: 'source.js'

console.log JSON.stringify linetokens, null, 2
```

Outputs:

```js
[
  [
    {
      "value": "var",
      "scopes": [
        "source.js",
        "storage.modifier.js"
      ]
    },
    {
      "value": " hello ",
      "scopes": [
        "source.js"
      ]
    },
    {
      "value": "=",
      "scopes": [
        "source.js",
        "keyword.operator.js"
      ]
    },
    {
      "value": " ",
      "scopes": [
        "source.js"
      ]
    },
    {
      "value": "'",
      "scopes": [
        "source.js",
        "string.quoted.single.js",
        "punctuation.definition.string.begin.js"
      ]
    },
    {
      "value": "world",
      "scopes": [
        "source.js",
        "string.quoted.single.js"
      ]
    },
    {
      "value": "'",
      "scopes": [
        "source.js",
        "string.quoted.single.js",
        "punctuation.definition.string.end.js"
      ]
    },
    {
      "value": ";",
      "scopes": [
        "source.js",
        "punctuation.terminator.statement.js"
      ]
    }
  ],
  [
    {
      "value": "console",
      "scopes": [
        "source.js",
        "entity.name.type.object.js.firebug"
      ]
    },
    {
      "value": ".log",
      "scopes": [
        "source.js",
        "support.function.js.firebug"
      ]
    },
    {
      "value": "(",
      "scopes": [
        "source.js",
        "meta.brace.round.js"
      ]
    },
    {
      "value": "'",
      "scopes": [
        "source.js",
        "string.quoted.single.js",
        "punctuation.definition.string.begin.js"
      ]
    },
    {
      "value": "Hello, ",
      "scopes": [
        "source.js",
        "string.quoted.single.js"
      ]
    },
    {
      "value": "'",
      "scopes": [
        "source.js",
        "string.quoted.single.js",
        "punctuation.definition.string.end.js"
      ]
    },
    {
      "value": " ",
      "scopes": [
        "source.js"
      ]
    },
    {
      "value": "+",
      "scopes": [
        "source.js",
        "keyword.operator.js"
      ]
    },
    {
      "value": " hello",
      "scopes": [
        "source.js"
      ]
    },
    {
      "value": ")",
      "scopes": [
        "source.js",
        "meta.brace.round.js"
      ]
    },
    {
      "value": ";",
      "scopes": [
        "source.js",
        "punctuation.terminator.statement.js"
      ]
    }
  ]
]
```

### Loading Grammars From Modules

textlex exposes the method `requireGrammarsSync`, for loading grammars from
npm modules. The usage is as follows:

```bash
npm install atom-language-clojure
```

```coffee
textlex = require 'textlex'
textlexer = new textlex()
textlexer.requireGrammarsSync
  modulePath: require.resolve('atom-language-clojure/package.json')
```

### Developing

* Clone this repository `git clone https://github.com/jonruttan/textlex`
* Update the submodules by running `git submodule update --init --recursive`
* Run `npm install` to install the dependencies, compile the CoffeeScript, and
  build the grammars
* Run `npm test` to run the specs

:green_heart: Pull requests are greatly appreciated and welcomed.
