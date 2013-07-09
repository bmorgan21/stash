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
                locations = _.filter(locations, (el) ->
                    return el.distance < 25
                )
                res.json(locations)
        )

    form: (req, res, next) =>
        models.Location.findById(req.params.id, (err, location) ->
            if (err)
                next(err)
            else
                vars = {}
                if (location)
                    vars = location.toObject()
                    vars.lng = vars.loc[0]
                    vars.lat = vars.loc[1]
                res.render('location.create.html', {vars: vars})
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
            vicinity: req.body.vicinity
            }

        default_id = '' + new mongoose.Types.ObjectId()
        models.Location.findByIdAndUpdate(req.params.id or default_id, data, {upsert:true},
            (err, obj) ->
                if (err)
                    vars = req.body
                    errors = {address: (''+err).replace(/'/g, '"')}
                    res.render('location.create.html', {vars:vars, errors:errors})
                else
                    res.redirect("/location/edit/#{obj.id}/")
                )

        #    tags: req.body.tags
        #    photos: req.body.photos,

exports.controller = new LocationController()
