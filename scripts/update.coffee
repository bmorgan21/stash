_ = require('underscore')
models = require('../models')

database = require('../config/database')
database.configure()

models.Location.find({}, (err, locations) ->
    _.each(locations, (location) ->
        console.log(location)
        if (not location.cat_icon)
            console.log(location.icon)
            location.cat_icon = location.icon
            location.save()
    )
)
