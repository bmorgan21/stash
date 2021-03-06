mongoose = require('mongoose')
mongoose = require('mongoose')
Schema = mongoose.Schema

schema = Schema({
    user: {type: Schema.Types.ObjectId,ref:'User'},
    reference: String,
    name: String,
    address: String,
    phone_number: String,
    international_phone_number:String,
    loc: {
        index: {type:'2dsphere'},
        type: [Number]
        },
    icon: String,
    cat_icon: String,
    photos: [Schema.Types.Mixed]
    price_level: {type:Number, max:4, min:0},
    rating: Number,
    types: [String],
    url: String,
    website: String,
    tags:[Schema.Types.Mixed]
    vicinity: String,
    viewport: Schema.Types.Mixed,
    data: String
    })

schema.index({
    user: 1
    })

schema.index({user:1, name:1}, {unique:true})

schema.virtual("coords")
    .get(() ->
        return {
            lat: this.loc[1],
            lng: this.loc[0]
          }
        )
    .set((map) ->
        this.loc[0] = map.lng
        this.loc[1] = map.lat
        return this.loc
    )
schema.set('toJSON',
    virtuals: true
    getters: false
    minimize: false
)

exports.schema = schema
