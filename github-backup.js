var fs = require('fs')
  , util = require('util')
  , exec = require('child_process').exec
  , repoList = [];

function queueBackup(list) {
	list.forEach(function(repo){
    repoList.push(repo.ssh_url);
  });
}

function dequeueBackup() {
  if ( repoList.length ) {
    runCommand( util.format( "git clone %s", repoList.shift() ), dequeueBackup );
  }
}

runCommand = function( command, callback ) {
  console.log( "\t" + command );
  exec( command, {maxBuffer: 5 * 1024 * 1024}, function( err, stdout, stderr ) {
    result = { stdout: stdout, stderr: stderr, err: err };

    // console.log( err );
    console.log( stdout );
    // console.log( stderr );
    if ( err === null ) {
      // nothing to see here
    } else {
      console.log( "Error!" );
      console.log( err );
      result.success = false;
    }
    if ( 'undefined' !== typeof callback ) {
      callback.call( result );
    }
  } );
};

process.chdir('repos');

// Loop through args and parse
process.argv.forEach(function (val) {
  if ( /\.json$/i.test( val ) ) {
  	var list = JSON.parse(fs.readFileSync(val));
  	queueBackup(list);
  }
});

// Kick off the process
dequeueBackup();