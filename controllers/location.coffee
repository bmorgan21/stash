base = require('./base')
http = require('http')
mongoose = require('mongoose')
_ = require('underscore')

BaseController = base.BaseController
models = require('../models')
lib = require('../lib')

class LocationController extends BaseController
    icon_filters: (locations) ->
        result = {}
        _.each(locations, (location) ->
            if (not result[location.cat_icon])
                result[location.cat_icon] = 0
            result[location.cat_icon]++
        )

        return _.sortBy(_.map(result, (val, key) ->
            return [val, key]
        ), (el) ->
            return -el[0]
        )

    do_search: (coords, user, cb) =>
        lng = coords.lng
        lat = coords.lat

        miles = (num) -> num / 3959

        #query already returns the closest result first, results sorted by distance
        models.Location.find({user:user, loc: {$nearSphere: [lng, lat], $maxDistance: miles(25) }}, # using Miles
            (err, locations) ->
                if (not err)
                    locations = _.map(locations, (el) ->
                        obj = el.toJSON() #Location is setup to include virtuals in toJSON
                        obj.distance = lib.distance.getDistanceAsMiles(coords, el.coords)
                        return obj
                    )

                cb(err, locations)
            )

    index: (req, res, next) =>
        process = (err, locations) =>
            if (err)
                next(err)
            else
                res.render('index.html', {locations:locations, icon_filters:@icon_filters(locations)})

        if (req.coords)
            @do_search(req.coords, req.user, process)
        else
            models.Location.find({user:req.user}, process)

    view: (req, res, next) =>
        models.Location.findOne({_id:req.params.id, user:req.user}, (err, location) ->
            if (err)
                next(err)
            else
                res.render('location.view.html', {
                    location:location,
                    coords: req.coords,
                    distance: if req.coords then lib.distance.getDistanceAsMiles(req.coords, location.coords) else null
                })
            )

    all: (req, res, next) =>
        models.Location.find({user:req.user}, (err, locations) =>
            if (err)
                next(err)
            else
                res.render('location.all.html', {locations:locations, icon_filters:@icon_filters(locations)})
        )

    search: (req, res, next) =>
        lat = parseFloat(req.query.lat)
        lng = parseFloat(req.query.lng)

        @do_search({lat:lat, lng:lng}, req.user, (err, locations) =>
            if (err)
                next(err)
            else
                res.json([@icon_filters(locations), locations])
        )

    form: (req, res, next) =>
        models.Location.findOne({_id:req.params.id, user:req.user}, (err, location) ->
            if (err)
                next(err)
            else
                vars = {}
                if (location)
                    vars = location.toObject()
                    [vars.lng, vars.lat] = vars.loc
                res.render('location.create.html', {vars: vars, exists:req.params.id})
            )

    save_update: (req, res, next) =>
        errors = {}
        if (not req.body.lng or not req.body.lat)
            errors['address'] = 'ERROR: Unable to geocode address'

        if (Object.keys(errors).length > 0)
            vars = req.body
            res.render('location.create.html', {vars:vars, errors:errors, exists:req.params.id})
        else
            data = {
                user: req.user,
                reference: req.body.reference,
                name: req.body.name,
                address: req.body.address,
                phone_number: req.body.phone_number,
                international_phone_number: req.body.international_phone_number,
                loc: [req.body.lng, req.body.lat],
                icon: req.body.icon,
                cat_icon: req.body.cat_icon,
                price_level: req.body.price_level,
                rating: req.body.rating,
                types: if req.body.types then JSON.parse(req.body.types) else [],
                url: req.body.url,
                website: req.body.website,
                vicinity: req.body.vicinity,
                data: req.body.data,
                photos: if req.body.photos then JSON.parse(req.body.photos) else []
                }

            default_id = '' + new mongoose.Types.ObjectId()
            models.Location.findOneAndUpdate({_id:req.params.id or default_id, user:req.user}, data, {upsert:true},
                (err, obj) ->
                    if (err)
                        vars = req.body
                        errors = {address: (''+err).replace(/'/g, '"')}
                        res.render('location.create.html', {vars:vars, errors:errors, exists:req.params.id})
                    else
                        res.redirect("/location/view/#{obj.id}/")
                    )

    delete: (req, res, next) =>
        models.Location.findOneAndRemove({_id:req.params.id, user:req.user}, (err, location) ->
            if (err)
                next(err)
            else
                res.redirect("/")
            )

exports.controller = new LocationController()
