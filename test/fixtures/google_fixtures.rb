class GoogleFixtures
  def self.walker_street_response_hash
    {
      "results": [
        {
          "address_components": [
            {
              "long_name": "118",
              "short_name": "118",
              "types": [
                "street_number"
              ]
            },
            {
              "long_name": "Walker Street",
              "short_name": "Walker St",
              "types": [
                "route"
              ]
            },
            {
              "long_name": "Dandenong",
              "short_name": "Dandenong",
              "types": [
                "locality",
                "political"
              ]
            },
            {
              "long_name": "Victoria",
              "short_name": "VIC",
              "types": [
                "administrative_area_level_1",
                "political"
              ]
            },
            {
              "long_name": "Australia",
              "short_name": "AU",
              "types": [
                "country",
                "political"
              ]
            },
            {
              "long_name": "3175",
              "short_name": "3175",
              "types": [
                "postal_code"
              ]
            }
          ],
          "formatted_address": "118 Walker St, Dandenong VIC 3175, Australia",
          "geometry": {
            "bounds": {
              "northeast": {
                "lat": -37.9877233,
                "lng": 145.2153979
              },
              "southwest": {
                "lat": -37.9877349,
                "lng": 145.2153864
              }
            },
            "location": {
              "lat": -37.9877349,
              "lng": 145.2153979
            },
            "location_type": "RANGE_INTERPOLATED",
            "viewport": {
              "northeast": {
                "lat": -37.98638011970851,
                "lng": 145.2167411302915
              },
              "southwest": {
                "lat": -37.98907808029151,
                "lng": 145.2140431697085
              }
            }
          },
          "place_id": "EiwxMTggV2Fsa2VyIFN0LCBEYW5kZW5vbmcgVklDIDMxNzUsIEF1c3RyYWxpYQ",
          "types": [
            "street_address"
          ]
        }
      ],
      "status": "OK"
    }

  end
end
