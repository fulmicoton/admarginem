tuberous = require 'tuberous'
potato = require 'potato'


JobType = potato.String

Job = tuberous.Model
    
    static:
        collectionName: "jobs"
    
    components:
        name: potato.String
        type: JobType
        creationDate: potato.String
        
    methods:
        url: ->
            '/api/jobs/' + @_id.toString()
        documents: (cb)->
            filter = {job: @_id}
            AnnotatedDocument.find filter, cb

AnnotatedDocument = tuberous.Model
    components:
        job: tuberous.ForeignObject(Job)
        data: potato.Literal
    static:
        collectionName: "documents"

module.exports =
    AnnotatedDocument: AnnotatedDocument
    Job: Job
