#!/usr/bin/env node
require('coffee-script/register');

var prompt = require('prompt'),
    optimist = require('optimist');

var mongoose = require('mongoose');

var pm2 = require('pm2');
var os = require('os');
var fs = require('fs');
var path = require('path');

var Package = require('./package.json');

var config = {
  listen: 5678,
  serverName: os.hostname(),
  shell: 'sh',
  mongodb: "mongodb://127.0.0.1:27017/anthTrigger"
};

// Read defaults from exist config file
var configFile = path.join(process.env.HOME, './.anthTrigger.config.json');
if(fs.existsSync(configFile)) {
  config = require(configFile);
}

var schema = {
  properties: {
    'listen': {
      description: 'Enter the listening port',
      type: 'number',
      pattern: /^\d+$/,
      message: 'Port must be numbers',
      hidden: false,
      default: config.listen,
      required: true
    },
    'serverName': {
      description: 'Enter the server name',
      type: 'string',
      message: 'Server name must be letters',
      hidden: false,
      default: config.serverName,
      required: true
    },
    'mongodb': {
      description: 'Enter the mongodb url',
      type: 'string',
      pattern: /^mongodb:\/\//,
      message: 'Mongodb url like: mongodb://127.0.0.1:27017/anthTrigger',
      hidden: false,
      default: config.mongodb,
      required: true
    },
    'shell': {
      description: 'Which shell to run the script',
      type: 'string',
      hidden: false,
      default: config.shell,
      required: true
    },
    'adminPass': {
      description: 'Enter the password for admin',
      type: 'string',
      hidden: true,
      required: false
    }

  }
};

function updateAdmin(dburl, pass, cb) {
  // Update administrator user password
  var con = mongoose.connect(dburl);
  con.connection.once('open', function() {
    var userModel = require('./lib/users/UserModel');
    userModel.update({
      name: 'admin'
    }, {
      $set: {
        password: pass,
        role: 'admin'
      }
    }, { upsert: true }, function(err, aff) {
      if(err) {
        cb('Update administrator password fail!');
      }
      cb(null);
      con.disconnect();
    });
  });
}

function callScript(dburl, shell, sid, args) {
  var con = mongoose.connect(dburl);
  con.connection.once('open', function() {
    scriptCtrl = require('./lib/script/controller');
    scriptCtrl
    .callScript(sid, args, {
      cwd: process.cwd(),
      env: process.env,
      shell: shell,
      stdio: 'inherit'
    })
    .then(function(cont, exc) {
      exc.on('close', function(code) {
        cont(null);
      })
    })
    .fail(function(cont, err) {
      console.error(err);
      cont(err)
    })
    .fin(function() {
      con.disconnect();
    });
  });
}

function exitPm2() {
  pm2.disconnect(function() { process.exit(0) });
}

var _argv = prompt.override = optimist.argv

switch(_argv._.shift()) {
  case 'setup':
    prompt.start();
    prompt.get(schema, function(err, result) {

      if(err) {
        console.error('\n', err);
        return
      }

      var password = result.adminPass;

      console.log('Update Configs:');
      console.log( JSON.stringify(result, null, '\t') );

      delete result.adminPass;

      // Update config.json
      var configJson = JSON.stringify(result, null, '\t');
      fs.writeFileSync(configFile, configJson);

      if(password) {
        updateAdmin(result.mongodb, password, function(err) {
          console.log('Done! Please restart anthTrigger!');
        });
      }

    });
    break;

  case 'start':
    pm2.connect(function(err) {
      var appEntryFile = path.join(__dirname, './index.js');
      pm2.start(appEntryFile, {name: 'anthTrigger' }, function(err, proc) {
        if(err) {
          console.error(err);
          // throw new Error(err);
          exitPm2();
          return
        }
        // Get all processes running
        pm2.list(function(err, process_list) {
          console.log('AnthTrigger start successful!');
          console.log('>> With pid: ', process_list[0].pid);

          // Disconnect to PM2
          exitPm2();
        });

      });
    });
    break;

  case 'pause':
    pm2.connect(function(err) {
      pm2.stop('anthTrigger', function(err, proc) {
        if(err) {
          console.error(err);
        }
        exitPm2();
      });
    });

    break;

  case 'stop':
    pm2.connect(function(err) {
      pm2.delete('anthTrigger', function(err, proc) {
        if(err) {
          console.error(err);
        }
        exitPm2();
      })
    })
    break;

  case 'kill':
    pm2.connect(function(err) {
      pm2.delete('anthTrigger', function(err, result) {
        if(err) {
          console.error(err);
        }
        exitPm2();
      });
    });
    break;

  case 'status':
    pm2.connect(function(err) {
      pm2.describe('anthTrigger', function(err, list) {
        if(err) {
          console.error(err);
        }
        if(!list || !list.length) {
          console.log('AnthTrigger not running...');
        } else {
          console.log(list);
        }
        exitPm2();
      });
    });
    break;

  case 'restart':
    pm2.connect(function(err) {
      pm2.restart('anthTrigger', function(err, result) {
        if(err) { console.error(err); }
        exitPm2();
      })
    })
    break;

  case 'version':
    console.log('anthTrigger (c) 网研(NAD)cLauncher');
    console.log('Current version: ' + Package.version);
    break;

  case 'run':
    var scriptId = _argv._.shift();
    var runArgs = _argv._;

    if(!scriptId) {
      console.error('Need scriptId as first argument');
      exitPm2();
      return ;
    }

    callScript(config.mongodb, config.shell, scriptId, runArgs);
    break;

  default:
    console.log('Syntax: ');
    console.log('\t anthtrigger <setup|start|pause|restart|stop|kill|version>');
    break;
}



