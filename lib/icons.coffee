_ = require('underscore')

exports.map = {
    '': 'http://maps.gstatic.com/mapfiles/place_api/icons/geocode-71.png',
    'Doctor': 'http://maps.gstatic.com/mapfiles/place_api/icons/doctor-71.png',
    'Electronics': 'http://maps.gstatic.com/mapfiles/place_api/icons/electronics-71.png',
    'Repair': 'http://maps.gstatic.com/mapfiles/place_api/icons/repair-71.png',
    'Government': 'http://maps.gstatic.com/mapfiles/place_api/icons/government-71.png',
    'Lodging': 'http://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png',
    'Museum': 'http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png',
    'Civic Building': 'http://maps.gstatic.com/mapfiles/place_api/icons/civic_building-71.png',
    'General Worship': 'http://maps.gstatic.com/mapfiles/place_api/icons/worship_general-71.png',
    'Aquarium': 'http://maps.gstatic.com/mapfiles/place_api/icons/aquarium-71.png',
    'Stadium': 'http://maps.gstatic.com/mapfiles/place_api/icons/stadium-71.png',
    'Generic Business': 'http://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png'
    'Generic Recreational': 'http://maps.gstatic.com/mapfiles/place_api/icons/generic_recreational-71.png',
    'Restaurant': 'http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png',
    'Cafe': 'http://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png',
    'Bar': 'http://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png',
    'Airport': 'http://maps.gstatic.com/mapfiles/place_api/icons/airport-71.png',
    'Art Gallery': 'http://maps.gstatic.com/mapfiles/place_api/icons/art_gallery-71.png',
    'Barber': 'http://maps.gstatic.com/mapfiles/place_api/icons/barber-71.png',
    'Shopping': 'http://maps.gstatic.com/mapfiles/place_api/icons/shopping-71.png',
    'Bowling': 'http://maps.gstatic.com/mapfiles/place_api/icons/bowling-71.png',
    'Fitness': 'http://maps.gstatic.com/mapfiles/place_api/icons/fitness-71.png',
    'Travel Agent': 'http://maps.gstatic.com/mapfiles/place_api/icons/travel_agent-71.png',
    'Camping': 'http://maps.gstatic.com/mapfiles/place_api/icons/camping-71.png',
    'Car Dealer': 'http://maps.gstatic.com/mapfiles/place_api/icons/car_dealer-71.png',
    'Gas Station': 'http://maps.gstatic.com/mapfiles/place_api/icons/gas_station-71.png',
    'Casino': 'http://maps.gstatic.com/mapfiles/place_api/icons/casino-71.png',
    'Dentist': 'http://maps.gstatic.com/mapfiles/place_api/icons/dentist-71.png',
    'Bus': 'http://maps.gstatic.com/mapfiles/place_api/icons/bus-71.png',
    'Train': 'http://maps.gstatic.com/mapfiles/place_api/icons/train-71.png'
    'Truck': 'http://maps.gstatic.com/mapfiles/place_api/icons/truck-71.png',
    'Bicycle': 'http://maps.gstatic.com/mapfiles/place_api/icons/bicycle-71.png',
    'Movies': 'http://maps.gstatic.com/mapfiles/place_api/icons/movies-71.png',
    'University': 'http://maps.gstatic.com/mapfiles/place_api/icons/university-71.png',
    'School': 'http://maps.gstatic.com/mapfiles/place_api/icons/school-71.png',
    'Wine': 'http://maps.gstatic.com/mapfiles/place_api/icons/wine-71.png',
    'Golf': 'http://maps.gstatic.com/mapfiles/place_api/icons/golf-71.png',
    'Tennis': 'http://maps.gstatic.com/mapfiles/place_api/icons/tennis-71.png',
    'Baseball': 'http://maps.gstatic.com/mapfiles/place_api/icons/baseball-71.png',
    'Monument': 'http://maps.gstatic.com/mapfiles/place_api/icons/monument-71.png',
    'Historic': 'http://maps.gstatic.com/mapfiles/place_api/icons/historic-71.png',
    'Zoo': 'http://maps.gstatic.com/mapfiles/place_api/icons/zoo-71.png',
    'Flower': 'http://maps.gstatic.com/mapfiles/place_api/icons/flower-71.png',
    'Amusement': 'http://maps.gstatic.com/mapfiles/place_api/icons/amusement-71.png',
    'Baby': 'http://maps.gstatic.com/mapfiles/place_api/icons/baby-71.png',
    'Ski': 'http://maps.gstatic.com/mapfiles/place_api/icons/ski-71.png',
    'Mountain': 'http://maps.gstatic.com/mapfiles/place_api/icons/mountain-71.png',
    'Beach': 'http://maps.gstatic.com/mapfiles/place_api/icons/beach-71.png',
    'Library': 'http://maps.gstatic.com/mapfiles/place_api/icons/library-71.png',
    'Supermarket': 'http://maps.gstatic.com/mapfiles/place_api/icons/supermarket-71.png',
    'Convenience': 'http://maps.gstatic.com/mapfiles/place_api/icons/convenience-71.png',
    'Courthouse': 'http://maps.gstatic.com/mapfiles/place_api/icons/courthouse-71.png',
    'Jewelry': 'http://maps.gstatic.com/mapfiles/place_api/icons/jewelry-71.png',
    'Pet': 'http://maps.gstatic.com/mapfiles/place_api/icons/pet-71.png',
    'Police': 'http://maps.gstatic.com/mapfiles/place_api/icons/police-71.png',
    'Post Office': 'http://maps.gstatic.com/mapfiles/place_api/icons/post_office-71.png',
    'Taxi': 'http://maps.gstatic.com/mapfiles/place_api/icons/taxi-71.png',
    'ATM': 'http://maps.gstatic.com/mapfiles/place_api/icons/atm-71.png'
    }

exports.list = _.sortBy(_.map(exports.map,
    ((val, key) ->
        return [key, val]
    )),
    ((val) ->
        return val[0]
    )
)