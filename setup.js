#!/usr/bin/env node
require('coffee-script/register');

var prompt = require('prompt'),
    optimist = require('optimist');

var mongoose = require('mongoose');

var pm2 = require('pm2');
var os = require('os');
var fs = require('fs');
var path = require('path');

var config = {
  listen: 5678,
  serverName: os.hostname(),
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
      pattern: /^\w+$/,
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
        password: pass
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

var _argv = prompt.override = optimist.argv

switch(_argv._[0]) {
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
      pm2.start(appEntryFile, { name: 'anthTrigger' }, function(err, proc) {
        if(err) {
          console.error(err);
          throw new Error(err);
        }
        // Get all processes running
        pm2.list(function(err, process_list) {
          console.log(process_list);

          // Disconnect to PM2
          pm2.disconnect(function() { process.exit(0) });
        });

      });
    })
    break;

  default:
    console.log('Syntax: \n');
    console.log('\t anthtrigger <setup|start>');
    break;
}


