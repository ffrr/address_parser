require 'net/http'
require 'uri'
require 'json'
require 'base64'

module Services

  class ParseWithGoogleMapsApiService

    def initialize(address)
      @address = address
    end

    def parse
      google_maps_results = {}

      uri = URI.parse(prepare_google_maps_api_url)
      http = Net::HTTP.new(uri.host)
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      response = JSON.parse(response.body) if response.code == "200"

      if response && response["status"] == "OK"
        response["results"][0]["address_components"].each do |component|
          case component["types"][0]
            when "subpremise"
              google_maps_results[:unit] = component["long_name"]
            when "street_number"
              google_maps_results[:number] = component["long_name"]
            when "route"
              google_maps_results[:street] = component["long_name"]
            when "locality"
              google_maps_results[:suburb] = component["long_name"]
            when "administrative_area_level_1"
              google_maps_results[:state] = component["short_name"]
            when "postal_code"
              google_maps_results[:postcode] = component["long_name"]
          end
        end

        if google_maps_results[:street]
          google_maps_results[:street_type] = AddressParser::StreetTypes::STREET_TYPES.flatten.detect do |s|
            @street_type_pattern  = Regexp.new(
              "(?<=[\\s|,])#{s}(?=(?:\\s\\d)|\\z)",
              Regexp::IGNORECASE
            )
            google_maps_results[:street] =~ @street_type_pattern
          end
        end

        if google_maps_results[:street_type]
          google_maps_results[:street] = google_maps_results[:street].gsub(google_maps_results[:street_type], '').strip
        end
      end

      google_maps_results
    end

    def prepare_google_maps_api_url
      url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(@address)},+Australia"

      unless AddressParser.configuration.nil?
        if AddressParser.configuration.google_maps_client_id && AddressParser.configuration.google_maps_cryptographic_key
          url += "&client=#{AddressParser.configuration.google_maps_client_id}"
          url += "&channel=address-parser"
          signature = generate_signature(url)
          url += "&signature=#{signature}"
        elsif AddressParser.configuration.google_maps_api_key
          url += "&key=#{AddressParser.configuration.google_maps_api_key}"
        end
      end

      url
    end

    private

     # stolen from https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/lookups/google_premier.rb
    def generate_signature(url)
      raw_private_key = url_safe_base64_decode(AddressParser.configuration.google_maps_cryptographic_key)
      digest = OpenSSL::Digest.new('sha1')
      raw_signature = OpenSSL::HMAC.digest(digest, raw_private_key, url)
      url_safe_base64_encode(raw_signature)
    end

    def url_safe_base64_decode(base64_string)
      Base64.decode64(base64_string.tr('-_', '+/'))
    end

    def url_safe_base64_encode(raw)
      Base64.encode64(raw).tr('+/', '-_').strip
    end

  end

end
