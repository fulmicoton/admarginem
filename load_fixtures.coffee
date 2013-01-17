#!/bin/env node

Job = require "./models/job"

job = Job.make
    name: "Right or wrong quizz"
    creationDate: "2012-10-01"

job.save ->
    console.log "done."
    db = require './models/db'
    db.quit()

