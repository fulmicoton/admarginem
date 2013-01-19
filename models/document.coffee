model = require './model'
potato = require 'potato'
Job = require './job'

Document = model.Model
    
    components:
        job: model.ForeignObject(Job)
        data: potato.Literal
    static:
        collectionName: "documents"

#        indexes:
#            [ { "auth.protocol": 1, "auth.value": 1} ]


module.exports = Document