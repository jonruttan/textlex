path = require 'path'
fs = require 'fs-plus'
optimist = require 'optimist'
Textlex = require './textlex'

module.exports = ->
  cli = optimist.describe('h', 'Show this message').alias('h', 'help')
                .describe('i', 'Path to file or folder of grammars to include').alias('i', 'include').string('i')
                .describe('o', 'File path to write the JSON output to').alias('o', 'output').string('o')
                .describe('s', 'Scope name of the grammar to use').alias('s', 'scope').string('s')
                .describe('v', 'Output the version').alias('v', 'version').boolean('v')
                .describe('f', 'File path to use for grammar detection when reading from stdin').alias('f', 'file-path').string('f')
                .describe('t', 'Tab for JSON output (a string or the number of spaces to use)').alias('t', 'tab').default('t', '\t')
  optimist.usage """
    Usage: textlex [options] [file...]

    Lexically analyse text and output the tokens for each line in JSON format.

    If no input files are specified then the text to analyse is read from standard in.

    If no output file is specified then the JSON is written to standard out.
  """

  if cli.argv.help
    cli.showHelp()
    return

  if cli.argv.version
    {version} = require '../package.json'
    console.log(version)
    return

  outputPath = cli.argv.output
  outputPath = path.resolve(outputPath) if outputPath

  textlex = new Textlex(includePath: cli.argv.include)

  stringify = (tokens, tab) ->
    JSON.stringify tokens, null, tab

  output = (outputPath, tokens, tab) ->
    if outputPath
      fs.writeFileSync(outputPath, stringify tokens, tab)
    else
      console.log(stringify tokens, tab)

  if cli.argv._.length
    for filePath in cli.argv._
      filePath = path.resolve(filePath)
      unless fs.isFileSync(filePath)
        console.error("Specified path is not a file: #{filePath}")
        process.exit(1)
        return

      tokens = textlex.lexSync({filePath, scopeName: cli.argv.scope})
      output outputPath, tokens, cli.argv.tab
  else
    filePath = cli.argv.f
    process.stdin.resume()
    process.stdin.setEncoding('utf8')
    fileContents = ''
    process.stdin.on 'data', (chunk) -> fileContents += chunk.toString()
    process.stdin.on 'end', ->
      tokens = textlex.lexSync({filePath, fileContents, scopeName: cli.argv.scope})
      output outputPath, tokens, cli.argv.tab
