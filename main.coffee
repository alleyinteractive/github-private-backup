prompt = require 'prompt'
GitHubSync = require './lib/github-sync'
GitBackup = require './lib/git-backup'

process.chdir 'repos'
prompt.start()

prompt.get ['username', 'password'], (err, result) ->
	return 1 if err

	runner = new GitHubSync(result.username, result.password)
	runner.getAllPrivateRepos (repos = []) ->
		# console.log repos
		new GitBackup repos if repos.length
