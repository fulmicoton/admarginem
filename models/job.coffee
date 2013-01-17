model = require './model'
potato = require 'potato'


Job = model.Model
    
    components:
        name: potato.String
        creationDate: potato.String

    static:
        collectionName: "job"
        indexes:
            [ { "auth.protocol": 1, "auth.value": 1} ]

    methods:
        addAuthMethod: (credentials)->
            # use AuthMethod for validation
            @credentials.push credentials

module.exports = Job