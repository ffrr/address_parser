require 'test_helper'

class TestAddressParser < Minitest::Test

  def test_initializer_on_address_parser_module
    address1 = AddressParser::Base.new('1107/2 Cunningham Street, Sydney NSW 2000').process_address
    address2 = AddressParser.new('1107/2 Cunningham Street, Sydney NSW 2000').process_address
    assert_equal address1, address2
  end

  def test_parsing_full_address_with_all_attributes
    address = AddressParser::Base.new('1107/2 Cunningham Street, Sydney NSW 2000')
      .process_address

    assert_equal '1107',       address[:unit]
    assert_equal '2',          address[:number]
    assert_equal 'Cunningham', address[:street]
    assert_equal 'Street',     address[:street_type]
    assert_equal 'Sydney',     address[:suburb]
    assert_equal 'NSW',        address[:state]
    assert_equal '2000',       address[:postcode]
  end

  def test_parsing_address_when_unit_has_words_and_starts_with_number
    address = AddressParser::Base.new('1108 The Connaught 187-189 Liverpool St')
      .process_address

    assert_equal '1108 The Connaught', address[:unit]
    assert_equal '187-189',            address[:number]
    assert_equal 'Liverpool',          address[:street]
    assert_equal 'Street',             address[:street_type]
  end

  def test_parsing_address_when_unit_has_words_and_starts_with_word
    address = AddressParser::Base.new('Charles Stuart Suite 3 Lev 1 23-25 Bay St')
      .process_address

    assert_equal 'Charles Stuart Suite 3 Lev 1', address[:unit]
    assert_equal '23-25',                        address[:number]
    assert_equal 'Bay',                          address[:street]
    assert_equal 'Street',                       address[:street_type]
  end

  def test_parsing_address_when_number_and_unit_contains_words
    address = AddressParser::Base.new('1/22a Victoria Avenue')
      .process_address

    assert_equal '1',        address[:unit]
    assert_equal '22a',      address[:number]
    assert_equal 'Victoria', address[:street]
    assert_equal 'Avenue',   address[:street_type]
  end

  def test_parsing_address_when_number_contains_characters
    address = AddressParser::Base.new('9b Adderstone Avenue')
      .process_address

    assert_equal '9b',         address[:number]
    assert_equal 'Adderstone', address[:street]
    assert_equal 'Avenue',     address[:street_type]
  end

  def test_parsing_address_with_unit_and_number_range
    address = AddressParser::Base.new('2/46-48 Abbotsford Pde')
      .process_address

    assert_equal '2',          address[:unit]
    assert_equal '46-48',      address[:number]
    assert_equal 'Abbotsford', address[:street]
    assert_equal 'Parade',     address[:street_type]
  end

  def test_parsing_with_streetname_containing_spaces
    address = AddressParser::Base.new('11/33 East Crescent Street')
      .process_address

    assert_equal '11',            address[:unit]
    assert_equal '33',            address[:number]
    assert_equal 'East Crescent', address[:street]
    assert_equal 'Street',        address[:street_type]
  end

  def test_parsing_with_unit_containing_characters
    address = AddressParser::Base.new('123E/85 Rouse Street')
      .process_address

    assert_equal '123E',   address[:unit]
    assert_equal '85',     address[:number]
    assert_equal 'Rouse',  address[:street]
    assert_equal 'Street', address[:street_type]
  end

  def test_parsing_with_pobox_and_full_address
    address = AddressParser::Base.new('PO box 12 121, Glenroy VIC 2000')
      .process_address

    assert_equal 'PO box',  address[:number]
    assert_equal '12 121',  address[:street]
    assert_equal 'VIC',     address[:state]
    assert_equal 'Glenroy', address[:suburb]
    assert_equal '2000',    address[:postcode]
  end

  def test_parsing_with_pobox_with_partial_address
    address = AddressParser::Base.new('pobox 121')
      .process_address

    assert_equal 'pobox', address[:number]
    assert_equal '121',   address[:street]
  end

  def test_parsing_with_pobox_having_chars_in_number
    address = AddressParser::Base.new('pobox 121a')
      .process_address

    assert_equal 'pobox', address[:number]
    assert_equal '121a',   address[:street]
  end

  def test_parsing_somewhat_dodgy_address
    address = AddressParser::Base.new('123 Something Somewhere')
      .process_address

    assert_equal '123',                 address[:number]
    assert_equal 'Something Somewhere', address[:street]
  end

  def test_parsing_total_dodgy_address
    address = AddressParser::Base.new('1088 Incredible unit Lev 7 1-123x Foo Bar')
      .process_address

    assert_equal '1088 Incredible unit Lev 7', address[:unit]
    assert_equal '1-123x',                     address[:number]
    assert_equal 'Foo Bar',                    address[:street]
  end

  def test_parsing_unparsabel_address_raises_error
    assert_raises AddressParser::Exceptions::ParsingError do
      AddressParser::Base.new('Dodgy address').process_address
    end
  end

  def test_parsing_address_with_multiple_street_types_as_part_of_street_name
    address = AddressParser::Base.new('61 Cope Street Lane Cove NSW 2066')
      .process_address

    assert_equal '61',               address[:number]
    assert_equal 'Cope Street Lane', address[:street]
    assert_equal 'Cove',             address[:street_type]
    assert_equal 'NSW',              address[:state]
    assert_equal '2066',             address[:postcode]
  end

  def test_parsing_address_having_double_postcode
    address = AddressParser::Base.new('2066 Some Street NSW 2066')
      .process_address

    assert_equal '2066',   address[:number]
    assert_equal 'Some',   address[:street]
    assert_equal 'Street', address[:street_type]
    assert_equal 'NSW',    address[:state]
    assert_equal '2066',   address[:postcode]
  end

  def test_calling_g_maps_api_for_address_without_commas
    response_hash =
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

  stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?%20%20%20%20%20%20%20%20channel="\
    "address-parser&%20%20%20%20%20%20%20%20key=123456&address=118%20Walker%20Street%20DANDENONG,"\
    "%20%20%20%20%20%20%20%20%20Australia").
    with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => response_hash.to_json, :headers => {})

    address = AddressParser::Base.new("118 Walker Street DANDENONG VIC 3175",
      "123456").process_address[:g_maps_results]

    assert_equal '118',       address[:number]
    assert_equal 'Walker',    address[:street]
    assert_equal 'Street',    address[:street_type]
    assert_equal 'Dandenong', address[:suburb]
    assert_equal 'VIC',       address[:state]
    assert_equal '3175',      address[:postcode]
  end
end
