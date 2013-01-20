#!/usr/bin/env coffee

util = require 'util'
express = require 'express' 
MongoStore = require('connect-mongo')(express)
config = require './config'
model = require './models/model'
async = require 'async'
readymade = require 'readymade'
tuberous = require 'tuberous'
config = require './config'


app = express.createServer()


# Configuration
# -----------------------------------

app.configure ->
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use readymade.middleware
        root: 'public'
        makefile: './readymade.Makefile'
    app.set 'views', __dirname + '/views'
    app.use express.favicon()
    #app.use express.cookieParser()
    #app.use express.session { secret: config.secret, store: mongoStore }
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
# -----------------------------------

app.get '/jobs/:id?', (req, res)->
    jobId = req.params.id
    model.Job.findById jobId, (err,job)->
        res.render 'job', 
            title: job.name
            job: job.toJSON()

app.get '/api/jobs/:id?', (req, res)->
    jobId = req.params.id
    model.Job.findById jobId, (err,job)->
        res.json
            name: job.name
            creationDate: job.creationDate
            type: job.type

app.get '/api/jobs/:id?/documents', (req, res)->
    job = model.Job.findById req.params.id, (error, job)->
        job.documents (err,documents)->
            res.json ( doc.data for doc in documents )

app.get '/', (req, res)->
    model.Job.find {}, (err, jobs)->
        res.render 'index', {title: "",  jobs: jobs}

runServer = (callback=(->))->
    app.listen 3000, ->
        port = app.address().port
        mode = app.settings.env
        console.log "Express server listening on port #{port} in #{mode} mode"
    callback()

tuberous.configure config.db

# ( (args...)-> User.ensureIndex args...)
runServer()

module.exports = app