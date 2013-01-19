#!/usr/bin/env coffee

util = require 'util'
express = require 'express' 
MongoStore = require('connect-mongo')(express)
config = require './config'
db = require './models/db'
Job = require './models/job'
async = require 'async'
readymade = require 'readymade'

mongoStore = new MongoStore(config.db)
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
# -----------------------------------


JOB_DATA = 
    name: "Relation Extraction Ford"
    docs: [
        {"url":"http://a", "data": "a" },
        {"url":"http://b", "data": "b" },
        {"url":"http://c", "data": "c" },
        {"url":"http://d", "data": "d" }
    ]

app.get '/jobs/:id?', (req, res)->
    Job.find {}, (err, jobs)->
        jobId = req.params.id
        Job.findById jobId, (err,job)->
            job.documents (err,documents)->
                documents = ( doc.data for doc in documents )
                res.render 'job', 
                    title: job.name
                    data: JSON.stringify
                        job: job.toData()
                        documents: documents

app.get '/', (req, res)->
    Job.find {}, (err, jobs)->
        res.render 'index', {title: "",  jobs: jobs}

runServer = (callback=(->))->
    app.listen 3000, ->
        port = app.address().port
        mode = app.settings.env
        console.log "Express server listening on port #{port} in #{mode} mode"
    callback()

# ( (args...)-> User.ensureIndex args...)
async.series [db.setup, runServer]

module.exports = app