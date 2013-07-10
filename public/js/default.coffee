
if(!nunjucks.env)
    # If not precompiled, create an environment with an HTTP    loader
    nunjucks.env = new nunjucks.Environment(new nunjucks.HttpLoader('/static/tpl'))

X.render = (tpl, ctx={}) -> #render a nunjucks template by name. ctx is the object of params to pass to it
    tpl = nunjucks.env.getTemplate(tpl)
    return tpl.render(ctx)

X.macro = (name, ctx={}, tpl='macros.html') -> #render a nunjucks macro by name.
    return nunjucks.env.getTemplate(tpl).getExported()[name](ctx)


$(() ->
    $doc = $(document)
    $doc.ajaxSuccess((event, xhr, settings) ->
        if(xhr.getResponseHeader("content-type") || '').toLowerCase().indexOf('json') > -1
            json = JSON.parse(xhr.responseText)
            if(not _.isEmpty(json.flash))
                evt = $.Event("flash", {flash: json.flash})
                $doc.trigger(evt)
                if (!evt.isDefaultPrevented()) #allow us to change or delete flashes before display
                    X.flash(evt.flash) if evt.flash

            if (json.redirect)
                evt = $.Event("redirect", {redirect: json.redirect})
                $doc.trigger(evt)
                if (!evt.isDefaultPrevented())    #allow us to abort redirect or override the location
                    window.location = evt.redirect
                    event.stopImmediatePropagation()
                    event.stopPropagation()
    )
    return
)
X.flash = (flashes) ->
    $cont = $("body div.flash-container")
    deduped = {}
    _.each(flashes, (messages, type) ->
        deduped[type] = []
        _.each(messages, (text) ->
            $existing = $cont.find(".alert-#{type}:visible .msg:contains('#{text}')")
            if $existing.length
                $existing.next().text((i, str) ->
                    return 'x'+ if str then (parseInt(str[1..], 10) + 1) else 2
                )
            else
                deduped[type].push(text)
        )
        if deduped[type].length == 0
            delete deduped[type]
    )

    if not _.isEmpty(deduped)
        $cont.append(X.macro('flash', deduped))
        Behavior2.contentChanged('flash')

X.getCurrentPosition = (success_cb, error_cb, options) ->
    coords = JSON.parse($.cookie('coords') or '{}')
    window.coords = coords
    if (coords.lat and  coords.lng and coords.timestamp)
        coords.valid = (new Date() - new Date(coords.timestamp)) < 1 * 60 * 1000 # cache for a minute

    handle_success = (coords, success_cb) ->
        $.cookie('coords', JSON.stringify(coords))
        success_cb(new google.maps.LatLng(coords.lat, coords.lng))

    if (coords.valid)
        handle_success(coords, success_cb)
    else if (navigator.geolocation)
        navigator.geolocation.getCurrentPosition(((position) ->
            coords = position.coords
            handle_success({lat:coords.latitude, lng:coords.longitude, timestamp:new Date().toJSON()}, success_cb)
            ), error_cb)
    else
        alert('Functionality not available')

Behavior2.Class('flash', 'body div.flash-container .alert', ($ctx, that) ->
    setTimeout(() ->
        $ctx.fadeOut('slow')
    , 4200)
)
Behavior2.Class('flashContainer', 'body div.flash-container', ($ctx, that) ->
    $ctx.scrollToFixed({
        marginTop: 40
    })
)

Behavior2.Class('date-picker', 'body input.date-picker', ($ctx, that) ->
    $ctx.datepicker().on('changeDate', (ev) ->
        $ctx.datepicker('hide')
        )
)

Behavior2.Class('formfill', 'form', ($ctx, that) ->
    $ctx.values($ctx.data('vars'))
    $ctx.errors($ctx.data('errors'))
    $ctx.trigger('initialized')
)

Behavior2.Class('loginrequired', '.login-required', ($ctx, that) ->
    $('#login-modal').modal()
)

$.fn.typeahead.defaults['matcher'] = (item) ->
    return true

$.fn.typeahead.defaults['sorter'] = (items) ->
    return $(items).map((i, el) ->
        JSON.stringify(el)
    )

$.fn.typeahead.defaults['highlighter'] = (json_item) ->
    item = JSON.parse(json_item)

    query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    return item['name'].replace(new RegExp('(' + query + ')', 'ig'), ($1, match) ->
        return '<strong>' + match + '</strong>'
    )

$.fn.typeahead.defaults['updater'] = (json_item) ->
    item = JSON.parse(json_item)
    return item['selection']
