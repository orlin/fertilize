times = 9 # is not too many...
spawn = require('child_process').spawn

args = process.argv.splice(2)
if args.length > 0
  # Leading with number is optional when the default `times` is enough.
  times = parseInt args.shift() unless isNaN args[0]
  command = args.shift()

# TODO: process.exit(1) if `which command` is a *not found* blank.

howManyTimes = if times is 0 then "until completion" else "up to #{times} times"
console.log "Running `#{command} #{args.join ' '}` #{howManyTimes}.\n"

run = (command, args, times, count = 1) ->
  child = spawn command, args
  child.stdout.on 'data', (buffer) -> console.log buffer.toString()
  child.stderr.on 'data', (buffer) -> console.log buffer.toString()
  child.on 'exit', (status) ->
    if status != 0 and (times is 0 or count < times)
      console.log "\nRetrying after the ##{count} run failed to complete.\n"
      run command, args, times, ++count
    else
      # The n-th status is the finally official process exit status.
      process.exit status

run command, args, times

