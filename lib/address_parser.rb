require 'address_parser/version'
require 'address_parser/states'
require 'address_parser/street_types'

module AddressParser
  class Base
    include States
    include StreetTypes

    def initialize(address)
      @address                = address

      @unit_and_number     = nil

      @state_pattern       = nil
      @street_pattern      = nil
      @postcode_pattern    = %r{\s?(?<postcode>(?:[2-7]\d{3}|08\d{2}))$}
      @unit_number_pattern = %r{(?<unit>.*)(?<=[\/|\s])+(?<number>[a-z\d-]*)$}
      #   ^\D*?
      #   (?:(?<unit>\d+(?=[\/|\s+]))[\/|\s+])?
      #   (?<number>(?:\d|-|\w)+)
      # }x

      @result = {}
    end

    def process_address
      extract_state
      extract_postcode
      extract_street_and_type
      extract_unit_and_number
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
        @street_pattern = Regexp.new(
          "(?<unit_and_number>.*)((?<=[A-z\\d])*\\s(?<street>[A-z\\s]+)\\s+#{st})(?=(,|\\z))",
          Regexp::IGNORECASE
        )

        @address       =~ @street_pattern
      end

      street_match          = @street_pattern.match(@address)
      @address              = @address.sub(@street_pattern, '')
      @unit_and_number      = street_match && street_match[:unit_and_number]
      @result[:street]      = street_match && street_match[:street]
      @result[:street_type] = STREET_TYPES.select { |s| s.include?(type_match) }.flatten[0]
    end

    def extract_suburb
      @address = @address.gsub(/[^\w\s]/, '').strip
      @result[:suburb] = @address
    end

    def extract_unit_and_number
      match            = @unit_number_pattern.match(@unit_and_number)
      @address         = @address.sub(@unit_and_number, '')
      @result[:unit]   = match && match[:unit].sub('/', '').strip
      @result[:number] = match && match[:number].strip
    end
  end
end
