querystring = require('querystring')
controllers = require('../controllers')
authController = controllers.authController
lc = controllers.locationController

requiresAuth = (permission) ->
    return (req, res, next) ->
        unless (req.user)
            console.log('/auth/login/?' + querystring.stringify({r: req.originalUrl}))
            res.redirect('/auth/login/?' + querystring.stringify({r: req.originalUrl}))
        else
            next()

exports.configure = (app) ->
    app.get('/', lc.index)
    app.get('/location/all/', requiresAuth(), lc.all)
    app.get('/location/search/', requiresAuth(), lc.search)
    app.get('/location/view/:id/', requiresAuth(), lc.view)
    app.get('/location/edit/:id/', requiresAuth(), lc.form)
    app.post('/location/edit/:id/', requiresAuth(), lc.save_update)
    app.get('/location/create/', requiresAuth(), lc.form)
    app.post('/location/create/', requiresAuth(), lc.save_update)

    # Redirect the user to Google for authentication.  When complete, Google
    # will redirect the user back to the application at
    #     /auth/google/return
    app.get('/auth/login/', authController.login)

    # Google will redirect the user to this URL after authentication.  Finish
    # the process by verifying the assertion.  If valid, the user will be
    # logged in.  Otherwise, authentication has failed.
    app.get('/auth/callback/', authController.login_callback)

    app.get('/auth/logout/', authController.logout)
