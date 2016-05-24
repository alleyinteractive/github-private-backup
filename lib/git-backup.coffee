exec = require('child_process').exec
ShellCommand = require './shell-command'
TarballDir = require './tarball-dir'

module.exports = class GitBackup
	constructor: (@repoList) ->
		@dequeueBackup()

	dequeueBackup: () ->
		if @repoList.length
			repo = @repoList.shift()
			ShellCommand.run "git clone --bare #{repo.url} /tmp/#{repo.name}.git", (result) =>
				if result.success is true
					TarballDir.run repo.name, (result) ->
						# Nothing to see here
				else
					console.error "Could not clone #{repo.url}!"

				@dequeueBackup()
		else
			console.log "No more repos to clone"
