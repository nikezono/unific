process.env.NODE_PATH = '/usr/local/lib/node_modules'

cp = require 'child_process'

task 'test','run tests', ->
    cp.spawn "mocha"
        ,[ "--compilers","coffee:coffee-script","./test/test.coffee","--reporter","spec"]
            ,{ stdio: 'inherit' }