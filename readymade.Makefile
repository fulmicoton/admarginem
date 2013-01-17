${build_path}:
	mkdir ${build_path}

${build_path}/public/js/admarginem.browserify.js: ${build_path} public/js/admarginem.coffee
	browserify public/js/admarginem.coffee -o ${build_path}/public/js/admarginem.browserify.js
