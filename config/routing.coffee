querystring = require('querystring')
controllers = require('../controllers')
authController = controllers.authController
lc = controllers.locationController

requiresAuth = (req, res, next) ->
        unless (req.user)
            console.log('/auth/login/?' + querystring.stringify({r: req.originalUrl}))
            res.redirect('/auth/login/?' + querystring.stringify({r: req.originalUrl}))
        else
            next()


exports.configure = (app) ->
    app.get('/', lc.index)
    app.all('/location/*', requiresAuth)
    app.get('/location/all/', lc.all)
    app.get('/location/search/', lc.search)
    app.get('/location/view/:id/', lc.view)
    app.get('/location/edit/:id/', lc.form)
    app.post('/location/edit/:id/', lc.save_update)
    app.get('/location/create/', lc.form)
    app.post('/location/create/', lc.save_update)
    app.get('/location/delete/:id/', lc.delete)

    # Redirect the user to Google for authentication.  When complete, Google
    # will redirect the user back to the application at
    #     /auth/google/return
    app.get('/auth/login/', authController.login)

    # Google will redirect the user to this URL after authentication.  Finish
    # the process by verifying the assertion.  If valid, the user will be
    # logged in.  Otherwise, authentication has failed.
    app.get('/auth/callback/', authController.login_callback)

    app.get('/auth/logout/', authController.logout)
