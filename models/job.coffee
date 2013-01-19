model = require './model'
potato = require 'potato'
Document = require "./Document"

JobType = potato.String

Job = model.Model
    
    static:
        collectionName: "jobs"

    components:
        name: potato.String
        type: JobType
        creationDate: potato.String

    methods:
        documents: (cb)->
            filter = {job: @_id}
            Document.find filter, cb

#        indexes:
#            [ { "auth.protocol": 1, "auth.value": 1} ]

module.exports = Job