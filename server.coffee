#!/usr/bin/env coffee

util = require 'util'
express = require 'express' 
MongoStore = require('connect-mongo')(express)
config = require './config'
db = require './models/db'
User = require './models/user'
async = require 'async'
readymade = require 'readymade'
mongoStore = new MongoStore(config.db)
app = express.createServer()

# Configuration
app.configure ->
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use readymade.middleware
        root: 'public'
        makefile: './readymade.Makefile'
    app.set 'views', __dirname + '/views'
    app.use express.favicon()
    app.use express.cookieParser()
    app.use express.session { secret: config.secret, store: mongoStore }
    app.set 'view engine', 'jade'
    app.set 'view options', layout: false

app.configure 'development', ->
    errorHandler = express.errorHandler
        dumpExceptions: true
        showStack: true
    app.use errorHandler

app.configure 'production', ->
    app.use express.errorHandler()

# Routes
app.get '/', (req, res)->
    res.render 'index', { title: ""}

runServer = (callback=(->))->
    app.listen 3000, ->
        port = app.address().port
        mode = app.settings.env
        console.log "Express server listening on port #{port} in #{mode} mode"
    callback()

async.series [db.setup, ( (args...)-> User.ensureIndex args...), runServer]

module.exports = app