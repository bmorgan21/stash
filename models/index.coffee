location = require('./location')
user = require('./user')

exports.init = (db) ->
    exports.Location = db.model('Location', location.schema)
    exports.User = db.model('User', user.schema)
