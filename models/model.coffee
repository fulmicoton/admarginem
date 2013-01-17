potato = require 'potato'
db = require './db'
mongodb = require 'mongodb'
ObjectID = mongodb.ObjectID
assert = require 'assert'
async = require 'async'

Model = potato.Model
    
    static:
        MAX_PER_REQUEST: 10
        indexes: [] 

        collectionName: -> throw "Not Implemented."

        ensureIndex: (callback=(->))->
            collectionName = potato.pick @collectionName
            potato.log "Ensuring indexes for #{ collectionName }"
            collection = @collection()
            ensureOneIndex = (index,callback)->
                collection.ensureIndex(index, callback)
            async.map @indexes, ensureOneIndex, (results)->callback()

        collection: ->
            collName = potato.pick @collectionName
            db.collection collName

        findById: (itemId, callback)->
            if (typeof itemId == "string")
                itemId = ObjectID itemId
            @collection().findOne({_id: itemId}, callback)
        
        findOne: (filter, callback)->
            assert.ok typeof filter == "object"
            @collection().findOne filter, callback

        find: (filter, callback, limit = 10)->
            assert.ok typeof filter == "object"
            @collection().find(filter).limit(limit).toArray callback
    
    methods:
        save: (callback)->
            data = @toData()
            console.log data
            if @_id?
                data._id = @_id
            @collection().save data, {safe: true, multi:false, upsert:true}, callback

Date = potato.Literal
    default: -> new Date()

module.exports = 
    Model: Model
    Date: Date