potato = require "potato"

AnnotationModel = potato.AnnotationModel
	components:
		correct: potato.Boolean

InputModel = potato.Model
	components:
		url: potato.String
		data: potato.String # just a JSON String

ChickSexerModel = potato.Model
	components:
		input: InputModel
		annotation: AnnotationModel

module.exports = 
	AnnotationModel: AnnotationModel
	InputModel: InputModel
	ChickSexerModel: ChickSexerModel
