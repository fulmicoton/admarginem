potato = require "potato"

# Models
AnnotationModel =  potato.Enum 
    default: "correct"
    choices: [ {id: "correct", name: "correct"}, {id: "wrong", name: "wrong"}  ]

InputModel = potato.Model
    components:
        url: potato.String 
        data: potato.String # just a JSON String

# Input view
InputView = potato.View
    el: '<div>'
    template: " 
        <h2>URL</h2>{{ url }}
        <h2>DATA</h2>{{ data }}
    "

# Annotate View
AnnotateView = potato.FormFactory.FormOf(AnnotationModel)
    el: '<div>'
    methods:
        up: ->
            
        down: ->
            $selectedInput = @input.selectedInput()
            $selectedInput.nextAll("input:first").click()
    events:
        "": "render": ->
            if not @keyboardIsBound?
                jwerty.key "↑", =>
                    @input.selectedInput().prevAll("input:first").click()
                jwerty.key "↓", =>
                    @input.selectedInput().nextAll("input:first").click()
                @keyboardIsBound = true

# Slider View
SliderView = potato.View
    el: '<input class="page-range" type="range">'
    
    delegates:
        val: "el"

    methods:
        setRange: (min, max)->
            @el.prop "min", min
            @el.prop "max", max

        context: (parent)->
            {val: parent.indexOffSet1()}

    events:
        "": render : (context)->
            @val context.val
        "@el": change: ->
            @trigger "change"

# Application
AdMarginemApp = potato.View
    
    template: """
        <div class="header">
            <h1>{{ job.name }}</h1>
            <span class="number">{{ indexOffSet1 }} / {{ size }} </span>
            <#slider/>
        </div>
        <div class='view-panel panel'>
        <#inputView/>
        </div>
        <div class='answer-panel panel'>
        <#annotateView/>
        </div>
    """
    properties:
        jobName: potato.String
        population: potato.CollectionOf(InputModel)
        annotations: potato.CollectionOf(AnnotationModel)
        sampleId: potato.Integer
        hasUnsavedChanges: potato.Boolean
    
    components:
        slider: SliderView
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
            @job = data.job
            console.log @job
            console.log typeof @job
            @population.setData data.documents
            for i in [0...@size()]
                @annotations.add AnnotationModel.make()
            @sampleId = 0
            @slider.setRange 1, @size()
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
        "@slider": change: ->
            page = @slider.val() - 1
            @goTo page

$ ->
    admarginem = AdMarginemApp.loadInto $ "#content"
    json = $("#jobdata").text()
    data = JSON.parse json
    jwerty.key '←', -> admarginem.goPrevious()
    jwerty.key '→', -> admarginem.goNext()
    admarginem.load data
    ###
    $.getJSON "json/population.json",   {}, (data)->
        jwerty.key '←', -> admarginem.goPrevious()
        jwerty.key '→', -> admarginem.goNext()
        admarginem.load data
    ###