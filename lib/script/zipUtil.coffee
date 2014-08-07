AdmZip = require('adm-zip')
pinyin = require 'pinyin'


# Create zip file from script list
exports.getZipBuffer = (scriptList)->
  zip = new AdmZip()

  for script in scriptList

    name = pinyin(script.title, {
      style: pinyin.STYLE_NORMAL
    }).join('-').toString()

    fileName = (script.scriptId or 0) + '_' + name + '.sh'

    entryContent = new Buffer(''+script.codes, 'utf-8')

    zip.addFile(fileName, entryContent, script.description)

  return zip.toBuffer()

