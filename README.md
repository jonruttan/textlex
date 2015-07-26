A lexical analyser using TextMate-style grammars: reads in code, returns an array containing an array of tokens for each line.

Based on code converted from the [Highlights](https://github.com/atom/highlights) project.

[![Build Status](https://travis-ci.org/jonruttan/textlex.svg)](https://travis-ci.org/jonruttan/textlex)

### Installing

```sh
npm install textlex
```

### Using

Run `textlex -h` for full details about the supported options.

To convert a source file to tokenized JSON run the following:

```sh
textlex file.coffee -o file.json
```

Now you have a `file.json` file with an array of line token arrays.

Check out the [examples](https://jonruttan.github.io/textlex/examples) to see
it in action.

#### Using in code

To convert a source file to tokens use the following code:

```coffee
textlex = require 'textlex'
textlexer = new textlex()
linetokens = textlexer.lexSync
  fileContents: "var hello = 'world';"
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
