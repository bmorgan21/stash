base = require('./base')
http = require('http')

BaseController = base.BaseController
models = require('../models')

class LocationController extends BaseController
    __geoCode__: (address, object, callback) =>
        googleGeoCodeApi = {
            host: 'maps.googleapis.com',
            port: 80,
            path: '/maps/api/geocode/json?sensor=false&address=' + escape(address),
            method: 'GET'
        }

        clientReq = http.get(googleGeoCodeApi, (clientRes) ->
            data = []

            clientRes.on('data', (chunk) ->
                data.push(chunk.toString())
            )

            clientRes.on('end', () ->
                googleObject = JSON.parse(data.join(''))

                error = null
                if (googleObject.status != 'OK')
                    error = 'Unable to find that location! [' + googleObject.status  + ']'
                else
                    geodata = googleObject.results.pop()
                    object.address = geodata.formatted_address
                    object.geodata = geodata

                    object.coords = {lon:geodata.geometry.location.lng, lat:geodata.geometry.location.lat}

                callback(error, object)
            )
        )

        clientReq.end()

    index: (req, res, next) =>
        models.Location.find({user:req.user}, (err, locations) ->
            res.render('index.html', {locations:locations})
            )

    form: (req, res, next) =>
        models.Location.findById(req.params.id, (err, location) ->
            res.render('location.create.html', {vars: location})
            )

    save: (req, res, next) =>
        l = models.Location({
            user: req.user,
            name: req.body.name,
            address: req.body.address,
            data_type: req.body.data_type,
            data: req.body.data
            })

        this.__geoCode__(l.address, l, (err, obj) ->
            vars = req.body
            errors = {}
            if (err)
                errors['address'] = err
                res.render('location.create.html', {vars:vars, errors:errors})
            else
                obj.save((err, obj) ->
                    res.redirect("/location/edit/#{obj.id}/")
                )
            )

    update: (req, res, next) =>
        models.Location.findOneAndUpdate({id: req.params.id}, {
            user: req.user,
            reference: req.body.reference,
            name: req.body.name,
            address: req.body.address,
            phone_number: req.body.phone_number,
            international_phone_number: req.body.international_phone_number,
            location: [req.body.lng, req.body.lat],
            icon: req.body.icon,
            price_level: req.body.price_level,
            rating: req.body.rating,
            types: req.body.types,
            url: req.body.url,
            website: req.body.website
            },
            {upsert: true},
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
        # models.Location.findById(req.params.id, (err, l) =>
        #     l.name = req.body.name
        #     l.address = req.body.address
        #     l.data_type = req.body.data_type
        #     l.data = req.body.data
        #     this.__geoCode__(l.address, l, (err, obj) ->
        #         vars = req.body
        #         errors = {}
        #         if (err)
        #             errors['address'] = err
        #         else
        #             obj.save((err, obj) ->
        #                 if (err)
        #                     errors['address'] = err
        #                 else
        #                     res.redirect("/location/edit/#{obj.id}/")
        #             )
        #         res.render('location.create.html', {vars:vars, errors:errors})
        #         )
        #     )

exports.controller = new LocationController()
