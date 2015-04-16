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

console.log linetokens
```

Outputs:

```js
[ [ { value: 'var', scopes: [Object] },
    { value: ' hello ', scopes: [Object] },
    { value: '=', scopes: [Object] },
    { value: ' ', scopes: [Object] },
    { value: '\'', scopes: [Object] },
    { value: 'world', scopes: [Object] },
    { value: '\'', scopes: [Object] },
    { value: ';', scopes: [Object] } ],
  [ { value: 'console', scopes: [Object] },
    { value: '.log', scopes: [Object] },
    { value: '(', scopes: [Object] },
    { value: '\'', scopes: [Object] },
    { value: 'Hello, ', scopes: [Object] },
    { value: '\'', scopes: [Object] },
    { value: ' ', scopes: [Object] },
    { value: '+', scopes: [Object] },
    { value: ' hello', scopes: [Object] },
    { value: ')', scopes: [Object] },
    { value: ';', scopes: [Object] } ] ]
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
