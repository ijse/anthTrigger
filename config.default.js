var os = require('os');
var path = require('path');

module.exports = {
  listen: 5678,
  serverName: os.hostname(),
  instances: 2,
  shell: 'sh',
  mongodb: "mongodb://127.0.0.1:27017/anthTrigger",
  backupDir: path.join(process.env.HOME, '/scripts_backup')
};