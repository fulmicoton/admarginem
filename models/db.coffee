config = require('../config').db

mongodb = require 'mongodb'
server = new mongodb.Server config.host, config.port, auto_reconnect: true
db = new mongodb.Db(config.db, server, {})
module.client = null

setup = (callback)->
    console.log "Setup DB"
    if not module.client?
        db.open (error, client)->
          if error
            console.log "Couldn't open connection to MongoDB."
            throw error
          else
            console.log "Connected to mongodb."
            module.client = client
            callback()
    else
        callback()

module.exports =
    setup: setup
    collection: (collectionName)->
        coll = new mongodb.Collection db, collectionName
        coll
