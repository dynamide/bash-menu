    var sys = require('sys')
    
    var exec = require('child_process').exec;
    
    function puts(error, stdout, stderr) { sys.puts(stdout) }
    
    exec("ls -la", puts);

exports.world = function() {
  console.log('Hello World');
}
