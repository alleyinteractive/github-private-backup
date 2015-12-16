prompt = require 'prompt'
GitHubSync = require './lib/github-sync'
GitBackup = require './lib/git-backup'

prompt.start()

prompt.get ['organization', 'username', 'password'], (err, result) ->
	return 1 if err

	runner = new GitHubSync(result.username, result.password, result.organization)
	runner.getAllPrivateRepos (repos = []) ->
		# console.log repos
		new GitBackup repos if repos.length
