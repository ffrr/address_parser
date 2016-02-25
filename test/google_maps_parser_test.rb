require 'test_helper'

class TestGoogleMapsParser < Minitest::Test
  def setup
    AddressParser.configure do |config|
      config.google_maps_api_key = nil
      config.google_maps_client_id = nil
      config.google_maps_cryptographic_key = nil
    end
  end

  def test_calling_google_maps_api_for_address_without_commas
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?"\
      "address=118%20Walker%20Street%20DANDENONG,%20Australia").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => GoogleFixtures.walker_street_response_hash.to_json)

    address = AddressParser::Base.new("118 Walker Street DANDENONG VIC 3175", true)
      .process_address[:google_maps_results]

    assert_equal '118',       address[:number]
    assert_equal 'Walker',    address[:street]
    assert_equal 'Street',    address[:street_type]
    assert_equal 'Dandenong', address[:suburb]
    assert_equal 'VIC',       address[:state]
    assert_equal '3175',      address[:postcode]
  end

  def test_calling_google_maps_api_using_api_key
    AddressParser.configure do |config|
      config.google_maps_api_key = '123456'
    end

    google_maps_api_service = Services::ParseWithGoogleMapsApiService.new("118 Walker Street DANDENONG VIC 3175")
    google_maps_api_url = google_maps_api_service.prepare_google_maps_api_url

    assert_match /key=123456/, google_maps_api_url
    refute_match /client=/, google_maps_api_url
    refute_match /signature=/, google_maps_api_url
  end

  def test_calling_google_maps_api_using_client_id_and_signature
    AddressParser.configure do |config|
      config.google_maps_client_id = '654321'
      config.google_maps_cryptographic_key = 'supersecretkey'
    end

    google_maps_api_service = Services::ParseWithGoogleMapsApiService.new("118 Walker Street DANDENONG VIC 3175")
    google_maps_api_url = google_maps_api_service.prepare_google_maps_api_url

    assert_match /client=654321/, google_maps_api_url
    assert_match /signature=FJuT8i_VFo2bd3q3JoMep103DuY=/, google_maps_api_url
    refute_match /key=/, google_maps_api_url
  end
end
