'use strict'

path = require 'path'
fs = require 'fs-plus'
Textlex = require './textlex'
cli = require 'yargs'
  .usage '''
    Usage: textlex [options] [file...]

    Lexically analyse text and output the tokens for each line in JSON format. \
    If no input files are specified then the text to analyse is read from \
    standard in. If no output file is specified then the JSON is written to \
    standard out.
  '''
  .option 'include',
    alias: 'i'
    describe: 'Path to file or folder of grammars to include'
    type: 'string'
  .option 'output',
    alias: 'o'
    describe: 'File path to write the JSON output to'
    type: 'string'
  .option 'scope',
    alias: 's'
    describe: 'Scope name of the grammar to use'
    type: 'string'
  .option 'file-path',
    alias: 'f'
    describe: 'File path to use for grammar detection when reading from stdin'
    type: 'string'

  .option 'tab',
    alias: 't'
    default: '\t'
    describe: 'Tab for JSON output (a string or the number of spaces to use)'
    type: 'string'
  .help()
  .alias 'h', 'help'
  .version ->
    {version} = require '../package.json'
    return version
  .alias 'v', 'version'


module.exports = ->
  # If the Tab argument is an integer, convert it to spaces
  if cli.argv.tab is String parseInt cli.argv.tab
    cli.argv.tab = ' '.repeat cli.argv.tab

  outputPath = cli.argv.output
  outputPath = path.resolve outputPath if outputPath

  textlex = new Textlex includePath: cli.argv.include

  stringify = (tokens, tab) ->
    JSON.stringify tokens, null, tab

  output = (outputPath, tokens, tab) ->
    tokensString = stringify tokens, tab
    if outputPath
      fs.writeFileSync outputPath, tokensString
    else
      console.log tokensString

  if cli.argv._.length
    for filePath in cli.argv._
      filePath = path.resolve filePath
      unless fs.isFileSync filePath
        console.error "Specified path is not a file: #{filePath}"
        process.exit 1
        return

      tokens = textlex.lexSync {filePath, scopeName: cli.argv.scope}
      output outputPath, tokens, cli.argv.tab
  else
    filePath = cli.argv.f
    process.stdin.resume()
    process.stdin.setEncoding 'utf8'
    fileContents = ''
    process.stdin.on 'data', (chunk) -> fileContents += chunk.toString()
    process.stdin.on 'end', ->
      tokens = textlex.lexSync {
        filePath,
        fileContents,
        scopeName: cli.argv.scope
      }
      output outputPath, tokens, cli.argv.tab
