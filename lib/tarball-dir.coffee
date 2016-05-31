exec = require('child_process').exec
fs = require 'fs'
ShellCommand = require './shell-command'

module.exports = class TarballDir
	constructor: (@slug, @callback) ->
		@dir = "/tmp/#{@slug}.git"
		@destination_dir = "./repos/#{@slug}.git"

		console.log "Tarballing #{@dir}"

	@run: (slug, callback) ->
		tbd = new @ slug, callback
		tbd.makeTarball tbd.removeDir

	makeTarball: (callback) ->
		ShellCommand.run "tar -czf #{@destination_dir}.tgz #{@dir}", (result) =>
			if true is result.success
				callback()
			else
				console.error "Could not tarball #{@dir}"
				@callback {success: false}

	removeDir: =>
		fs.stat "#{@destination_dir}.tgz", (err, stat) =>
			if err is null and stat.size > 0 and -1 isnt @destination_dir.indexOf('./repos/')
				ShellCommand.run "rm -rf #{@dir}", (result) =>
					if true is result.success
						console.log "#{@dir} successfull compressed"
						@callback {success: true}
					else
						console.error "Could not remove #{@dir}"
						@callback {success: false}
			else
				console.error "Could not stat #{@destination_dir}.tgz:"
				console.error err
