
model = require './model'
potato = require 'potato'

Credentials = potato.Model
    components:
        protocol: potato.String # TODO Have this a choice
        value: potato.String

User = model.Model
    
    components:
        username: potato.String
        creationDate: potato.String
        credentials: potato.ListOf(Credentials)

    static:
        collectionName: "users"

        indexes:
            [ { "auth.protocol": 1, "auth.value": 1} ]
        
        findOrCreate: (credentials, suggestion, promise)->
            if credentials.protocol? and credentials.value?
                filter = credentials: credentials
                @findOne filter, (err, user)->
                    if err?
                        promise.fail "failure"
                    else
                        if not user?
                            console.log "User creation required #{ credentials } , #{ suggestion }"
                            user = User.make()
                            user.username = suggestion.username #< TODO what if not unique
                            user.creationDate = new Date()
                            user.addAuthMethod credentials
                            console.log "Creating new user : #{user}"
                            user.save (err, newUser)->
                                if err? or not newUser?
                                    console.error "Couldn't create object in MongoDB", err
                                    promise.fail "Internal error"
                                else
                                    user._id = newUser._id
                                    user.id = user._id
                                promise.fulfill user
                        else
                            user.id = user._id
                            promise.fulfill user
            else
                console.error "protocol AND value should be defined. #{authMethod} is not a valid login"
                promise.fail "Internal error"

    methods:
        addAuthMethod: (credentials)->
            # use AuthMethod for validation
            @credentials.push credentials

module.exports = User
