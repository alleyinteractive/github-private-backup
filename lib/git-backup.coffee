util = require 'util'
exec = require('child_process').exec

module.exports = class GitBackup
	constructor: (@repoList) ->
		@dequeueBackup()

	dequeueBackup: () =>
		if @repoList.length
			@runCommand util.format("git clone %s", @repoList.shift()), @dequeueBackup
		else
			console.log "No more repos to clone!"

	runCommand: (command, callback) ->
		console.log command
		exec command, {maxBuffer: 5 * 1024 * 1024}, (err, stdout, stderr) =>
			result =
				stdout: stdout
				stderr: stderr
				err: err

			# console.log err
			console.log stdout
			# console.log stderr

			if err is null
				result.success = true
			else
				console.log( "Error!" );
				console.log( err );
				result.success = false;

			if 'function' is typeof callback
				callback result