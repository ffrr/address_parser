require 'address_parser/version'
require 'address_parser/states'
require 'address_parser/street_types'

module AddressParser
  class Base
    include States
    include StreetTypes

    def initialize(address)
      @address                = address

      @state_pattern       = nil
      @postcode_pattern    = %r{\s?(?<postcode>\d+)$}
      @unit_number_pattern = %r{
        ^\D*?
        (?:(?<unit>\d+(?=[\/|\s+]))[\/|\s+])?
        (?<number>(?:\d|-)+)
      }x

      @result = {}
    end

    def process_address
      puts @address

      extract_state
      extract_postcode
      extract_unit_and_number
      extract_street_and_type
      extract_suburb

      @result
    end

    def extract_postcode
      match              = @postcode_pattern.match(@address)
      @address           = @address.sub(@postcode_pattern, '')
      @result[:postcode] = match && match[:postcode]
    end

    def extract_state
      match = STATES.flatten.detect do |s|
        @state_pattern  = Regexp.new("\\s+#{s}\\s+", Regexp::IGNORECASE)
        @address       =~ @state_pattern
      end

      @address = @address.sub(@state_pattern, ' ')
      @result[:state] = STATES.select { |s| s.include?(match) }.flatten[0]
    end

    def extract_street_and_type
      type_match = STREET_TYPES.flatten.detect do |st|
        @street_pattern = Regexp.new("(?<street>\\w+)\\s+#{st}", Regexp::IGNORECASE)
        @address       =~ @street_pattern
      end

      street_match          = @street_pattern.match(@address)
      @address              = @address.sub(@street_pattern, '')
      @result[:street]      = street_match && street_match[:street]
      @result[:street_type] = type_match
    end

    def extract_suburb
      @address = @address.gsub(/[^\w\s]/, '').strip
      @result[:suburb] = @address
    end

    def extract_unit_and_number
      match            = @unit_number_pattern.match(@address)
      @address         = @address.sub(@unit_number_pattern, '')
      @result[:unit]   = match && match[:unit]
      @result[:number] = match && match[:number]
    end
  end
end
