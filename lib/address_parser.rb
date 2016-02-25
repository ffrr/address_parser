require 'address_parser/version'
require 'address_parser/states'
require 'address_parser/street_types'
require 'address_parser/exceptions'
require 'net/http'
require 'uri'
require 'json'

module AddressParser

  def self.new(address, g_maps_api_key=nil)
    Base.new(address, g_maps_api_key)
  end

  class Base
    include States
    include StreetTypes

    def initialize(address, g_maps_api_key=nil)
      @address             = address

      @unit_and_number     = nil
      @street_type_match   = nil
      @state_match         = nil

      @state_pattern       = nil
      @street_pattern      = nil
      @pobox_pattern       = %r{(?<pobox>p[.\s]?\s?o[.\s]?\s*box)\s(?<number>[\w\s]{1,6})}i
      @postcode_pattern    = %r{\s?(?<postcode>(?:[2-7]\d{3}|08\d{2}))$}
      @unit_number_pattern = %r{((?<unit>.*)(?<=[\/|\s])+)?(?<number>[a-z\d-]*)$}i

      @g_maps_api_key = g_maps_api_key
      @result = {}
    end

    def process_address
      set_state_pattern

      extract_pobox if has_pobox?

      extract_state
      extract_postcode

      set_street_unit_number_pattern

      extract_street_and_type if @street_pattern
      extract_unit_and_number if @unit_and_number

      attempt_to_save_address if result_is_funky? && @address =~ /\d+/
      raise AddressParser::Exceptions::ParsingError if result_is_funky?

      extract_suburb

      # only use Google maps for adress parsing when api_key is present
      make_g_maps_api_call if @g_maps_api_key

      @result
    end

    def make_g_maps_api_call
      g_maps_results = {}
      uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(@address)},
        +Australia&
        key=#{@g_maps_api_key}&
        channel=address-parser"
      )
      http = Net::HTTP.new(uri.host)
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      response = JSON.parse(response.body)

      if response["status"] == "OK"
        response["results"][0]["address_components"].each do |component|
          case component["types"][0]
            when "subpremise"
              g_maps_results[:unit] = component["long_name"]
            when "street_number"
              g_maps_results[:number] = component["long_name"]
            when "route"
              g_maps_results[:street] = component["long_name"]
            when "locality"
              g_maps_results[:suburb] = component["long_name"]
            when "administrative_area_level_1"
              g_maps_results[:state] = component["short_name"]
            when "postal_code"
              g_maps_results[:postcode] = component["long_name"]
          end
        end

        if g_maps_results[:street]
          g_maps_results[:street_type] = STREET_TYPES.flatten.detect do |s|
            @street_type_pattern  = Regexp.new(
              "(?<=[\\s|,])#{s}(?=(?:\\s\\d)|\\z)",
              Regexp::IGNORECASE
            )
            g_maps_results[:street] =~ @street_type_pattern
          end
        end

        if g_maps_results[:street_type]
          g_maps_results[:street] = g_maps_results[:street].gsub(g_maps_results[:street_type], '').strip
        end
      end

      @result[:g_maps_results] = g_maps_results
    end

    def extract_pobox
      match = @pobox_pattern.match(@address)

      @address         = @address.gsub(@pobox_pattern, '')
      @result[:number] = match && match[:pobox]
      @result[:street] = match && match[:number]
    end

    def extract_postcode
      match              = @postcode_pattern.match(@address)
      @address           = @address.gsub(@postcode_pattern, '').strip
      @result[:postcode] = match && match[:postcode]
    end

    def extract_state
      @address = @address.gsub(@state_pattern, '').strip
      @result[:state] = STATES.select { |s| s.include?(@state_match) }.flatten[0]
    end

    def extract_street_and_type
      street_match          = @street_pattern.match(@address)
      @address              = @address.gsub(@street_pattern, '')
      @unit_and_number      = street_match && street_match[:unit_and_number]
      @result[:street]      = street_match && street_match[:street]
      @result[:street_type] = STREET_TYPES.select { |s| s.include?(@street_type_match) }.flatten[0]
    end

    def extract_suburb
      @address         = @address.gsub(/[^\w\s]/, '').strip
      @result[:suburb] = @address.empty? ? nil : @address
    end

    def extract_unit_and_number
      match            = @unit_number_pattern.match(@unit_and_number)
      @address         = @address.gsub(@unit_and_number, '') if match

      @result[:unit]   = match[:unit] && match[:unit].gsub('/', '').strip if match
      @result[:number] = match[:number] && match[:number].strip if match
    end

    private

    def attempt_to_save_address
      pattern = %r{
      (?<unit>.*(?=(\s[\d]+)))?
      \s?
      (?<number>[a-z\d|-]+)
      \s?
      (?<street>[\w\s]+)
      }ix

      match = pattern.match(@address)
      @address = @address.gsub(pattern, '') if match

      @result[:unit] = match[:unit]
      @result[:number] = match[:number]
      @result[:street] = match[:street]
    end

    def result_is_funky?
      @result.values.compact.empty? && @address =~ /[^\d]+/
    end

    def has_pobox?
      @address =~ @pobox_pattern
    end

    protected

    def set_street_unit_number_pattern
      @street_type_match = STREET_TYPES.flatten.detect do |st|
        @street_pattern = Regexp.new(
          "
          (?:(?<unit_and_number>.*[\\d\\/]+[a-z]?)\\s)?
          ((?<street>[A-z\\s]+)\\s+#{st})
          (?=#{(@address =~ /,/).nil? ? '\\z' : ','})
          ",
          Regexp::IGNORECASE | Regexp::EXTENDED
        )

        @address =~ @street_pattern
      end

      @street_pattern = nil unless @address =~ @street_pattern
    end

    def set_state_pattern
      @state_match = STATES.flatten.detect do |s|
        @state_pattern  = Regexp.new(
          "(?<=[\\s|,])#{s}(?=(?:\\s\\d)|\\z)",
          Regexp::IGNORECASE
        )
        @address =~ @state_pattern
      end
    end
  end
end
