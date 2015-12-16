https = require 'https'
url = require 'url'
querystring = require 'querystring'

module.exports = class GitHubSync
	constructor: (username, password, @org) ->
		@headers =
			"Authorization": "Basic #{new Buffer(username + ":" + password).toString("base64")}"
			"Content-Type": "application/json"
			"User-Agent": username
		@host = "api.github.com"
		@page = 1
		@repos = []

	apiGet: (path, params, callback) ->
		console.log "Getting #{path}?#{querystring.stringify params}..."

		options =
			headers: @headers
			host: @host
			path: "#{path}?#{querystring.stringify params}"

		request = https.get options, callback

		request.on "error", (err) ->
		  console.error "GitHub request error: #{err}"

	getPrivateReposForNextPage: (callback) ->
		@apiGet "/orgs/#{@org}/repos", {per_page: 100, page: @page++, type: "private"}, (response) =>
			data = ""

			response.on "data", (chunk) =>
				data += chunk

			response.on "end", =>
				switch response.statusCode
					when 200
						newRepos = JSON.parse data
						for repo in newRepos
							@repos.push name: repo.name, url: repo.ssh_url

						if newRepos.length is 100
							@getPrivateReposForNextPage callback
						else
							# We're all done!
							callback()
					when 401
						throw new Error "401: Authentication failed."
					else
						console.error "Code: #{response.statusCode}"

			response.on "error", (err) ->
				console.error "GitHub response error: #{err}"

	getAllPrivateRepos: (callback) ->
		@getPrivateReposForNextPage =>
			callback @repos
