base = require('./base')
http = require('http')
mongoose = require('mongoose')
_ = require('underscore')

BaseController = base.BaseController
models = require('../models')
lib = require('../lib')

class LocationController extends BaseController
    do_search: (coords, user, cb) =>
        lng = coords.lng
        lat = coords.lat

        models.Location.find({user:user, loc: {$near: [lng, lat], $maxDistance:5}}, # just do distance of 5 in the mathematical world
            (err, locations) ->
                if (not err)
                    locations = _.map(locations, (el) ->
                        obj = el.toJSON({virtuals:true})
                        obj.distance = lib.distance.getDistanceAsMiles({lat:lat, lng:lng}, el.coords)
                        return obj
                    )

                    locations = _.filter(locations, (el) ->
                        return el.distance < 25
                    )

                    locations = _.sortBy(locations, (el) ->
                        return el.distance
                    )
                cb(err, locations)
            )

    index: (req, res, next) =>
        if (req.cookies.coords)
            coords = JSON.parse(req.cookies.coords)
            @do_search(coords, req.user, (err, locations) ->
                if (err)
                    next(err)
                else
                    res.render('index.html', {locations:locations})
            )
        else
            models.Location.find({user:req.user}, (err, locations) ->
                if (err)
                    next(err)
                else
                    res.render('index.html', {locations:locations})
            )
    view: (req, res, next) =>
        models.Location.findOne({_id:req.params.id, user:req.user}, (err, location) ->
            if (err)
                next(err)
            else
                coords = if req.cookies.coords then JSON.parse(req.cookies.coords) else null
                res.render('location.view.html', {
                    location:location,
                    coords:coords,
                    distance: if coords then lib.distance.getDistanceAsMiles(coords, location.coords) else null
                })
            )

    all: (req, res, next) =>
        models.Location.find({user:req.user}, (err, locations) ->
            if (err)
                next(err)
            else
                res.render('location.all.html', {locations:locations})
        )

    search: (req, res, next) =>
        lat = parseFloat(req.query.lat)
        lng = parseFloat(req.query.lng)

        @do_search({lat:lat, lng:lng}, req.user, (err, locations) ->
            if (err)
                next(err)
            else
                res.json(locations)
        )

    form: (req, res, next) =>
        models.Location.findOne({_id:req.params.id, user:req.user}, (err, location) ->
            if (err)
                next(err)
            else
                vars = {}
                if (location)
                    vars = location.toObject()
                    vars.lng = vars.loc[0]
                    vars.lat = vars.loc[1]
                res.render('location.create.html', {vars: vars, exists:req.params.id})
            )

    save_update: (req, res, next) =>
        data = {
            user: req.user,
            reference: req.body.reference,
            name: req.body.name,
            address: req.body.address,
            phone_number: req.body.phone_number,
            international_phone_number: req.body.international_phone_number,
            loc: [req.body.lng, req.body.lat],
            icon: req.body.icon,
            price_level: req.body.price_level,
            rating: req.body.rating,
            types: req.body.types,
            url: req.body.url,
            website: req.body.website,
            vicinity: req.body.vicinity,
            data: req.body.data
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

        #    tags: req.body.tags
        #    photos: req.body.photos,

    delete: (req, res, next) =>
        models.Location.findOneAndRemove({_id:req.params.id, user:req.user}, (err, location) ->
            if (err)
                next(err)
            else
                res.redirect("/")
            )

exports.controller = new LocationController()
