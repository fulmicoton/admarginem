potato = require "potato"

# Models
AnnotationModel =  potato.Boolean

InputModel = potato.Model
    components:
        url: potato.String
        data: potato.String # just a JSON String

# Input view
InputView = potato.View
    el: '<div class="view-panel panel">'
    template: "
        <h1>URL</h1>{{ url }}
        <h1>DATA</h1>{{ data }}
    "

# Annotate View
AnnotateView = potato.FormFactory.FormOf(AnnotationModel)
    el: '<div class="answer-panel panel">'
    events:
        "": "render": ->
            if not @keyboardIsBound?
                jwerty.key "↩", => @val !@val()
                jwerty.key "n", => @val false
                jwerty.key 'y', => @val true
                @keyboardIsBound = true

# Application
AdMarginemApp = potato.View
    
    template: """
        {{ indexOffSet1 }} / {{ size }}
        <#inputView/>
        <#annotateView/>
    """

    properties:
        population: potato.CollectionOf(InputModel)
        annotations: potato.CollectionOf(AnnotationModel)
        sampleId: potato.Integer
        hasUnsavedChanges: potato.Boolean
    
    components:
        inputView: InputView
            methods:
                context: (parent)->
                    parent.currentInput()
        annotateView: AnnotateView
            methods:
                context: (parent)->
                    parent.currentAnnotation()

    methods:
        load: (data)->
            @population.setData data
            for i in [0...@size()]
                @annotations.add AnnotationModel.make()
            @sampleId = 0
            @render()  

        saveCurrent: ->
            if @hasUnsavedChanges
                annotationValue = @annotateView.val()
                @annotations.item @sampleId, annotationValue
                @hasUnsavedChanges = false

        goTo: (sampleId)->
            if sampleId != @sampleId
                @saveCurrent()      
                @sampleId = sampleId
                @trigger "goto"
                @render()
                @hasUnsavedChanges = false

        goPrevious: ->
            if @sampleId > 0
                @goTo @sampleId-1
        
        goNext: ->
            if @sampleId < @population.size()-1
                @goTo @sampleId+1

        currentInput: ->
            @population.item @sampleId

        currentAnnotation: ->
            @annotations.item @sampleId

        indexOffSet1: ->
            @sampleId + 1

    delegates:
        size: "population"

    events:
        "@annotateView": "change": ->
            @hasUnsavedChanges = true

$ ->
    admarginem = AdMarginemApp.loadInto $ "#content"
    $.getJSON "json/population.json",   {}, (data)->
        jwerty.key '←', -> admarginem.goPrevious()
        jwerty.key '→', -> admarginem.goNext()
        admarginem.load data
