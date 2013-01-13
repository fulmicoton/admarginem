${build_path}:
	mkdir ${build_path}

${build_path}/js/admarginem.browserify.js: ${build_path} js/admarginem.coffee
	browserify js/admarginem.coffee -o ${build_path}/js/admarginem.browserify.js
