#!/bin/env node

Job = require "./models/job"


async = require 'async'

###
async.series([
    function(callback){
        // do some stuff ...
        callback(null, 'one');
    },
    function(callback){
        // do some more stuff ...
        callback(null, 'two');
    },
],



job = Job.make
    name: "Right or wrong quizz"
    creationDate: "2012-10-01"
### 

jobFixtures = [
        name: "Relation Extraction Ford"
        creationDate: "2012-10-01"
    ,
        name: "Car Sentiment analysis"
        creationDate: "2012-10-01"
]

Job.loadFixtures jobFixtures, ->
    console.log "done."
    db = require './models/db'
    db.quit()

