potato = require "potato"

AnnotationModel =  potato.Boolean

InputModel = potato.Model
	components:
		url: potato.String
		data: potato.String # just a JSON String

module.exports = 
	AnnotationModel: AnnotationModel
	InputModel: InputModel
	