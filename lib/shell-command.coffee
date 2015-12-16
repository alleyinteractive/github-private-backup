exec = require('child_process').exec

module.exports = class ShellCommand
	@run: (command, callback) ->
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
				console.error( "Error!" );
				console.error( err );
				result.success = false;

			if 'function' is typeof callback
				callback result