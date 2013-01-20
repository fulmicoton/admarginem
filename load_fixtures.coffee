#!/bin/env node

potato = require 'potato'
async = require 'async'
tuberous = require 'tuberous'
Job = require './models/job'
Document = require "./models/document"
config = require './config'

tuberous.configure config.db, ->

    jobFixtures = [
            _id: "000000000000000000000001"
            name: "Relation Extraction Ford"
            creationDate: "2012-10-01"
            type: "rightorwrong"
        ,
            _id: "000000000000000000000002"
            name: "Car Sentiment analysis"
            creationDate: "2012-10-01"
            type: "rightorwrong"
    ]

    docFixtures = [
            _id: "000000000000000000000003"
            job: "000000000000000000000001"
            data:
                url:"http://a"
                data: "a"
        ,
            _id: "000000000000000000000004"
            job: "000000000000000000000001"
            data:
                url:"http://b"
                data: "b"
        ,
            _id: "000000000000000000000005"
            job: "000000000000000000000001"
            data:
                url:"http://c"
                data: "c"
        ,
            _id: "000000000000000000000006"
            job: "000000000000000000000001"
            data:
                url:"http://d"
                data: "d"
    ]

    potato.log "Loading Fixtures for Job"
    Job.loadFixtures jobFixtures, ->
        console.log "Done."
        potato.log "Loading Fixtures for Document"
        Document.loadFixtures docFixtures, ->
            console.log "Done."
            tuberous.close()
