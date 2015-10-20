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
      @street_type_match   = nil
      @state_match         = nil

      @state_pattern       = nil
      @street_pattern      = nil
      @pobox_pattern       = %r{(?<pobox>p[.\s]?\s?o[.\s]?\s*box)\s(?<number>[\d\s]{1,6})}i
      @postcode_pattern    = %r{\s?(?<postcode>(?:[2-7]\d{3}|08\d{2}))}
      @unit_number_pattern = %r{((?<unit>.*)(?<=[\/|\s])+)?(?<number>[a-z\d-]*)$}i

      @result = {}
    end

    def process_address
      set_street_unit_number_pattern
      set_state_pattern

      extract_pobox if has_pobox?
      extract_street_and_type if @street_pattern
      extract_unit_and_number if @unit_and_number
      extract_state
      extract_postcode
      extract_suburb

      @result
    end

    def extract_pobox
      match = @pobox_pattern.match(@address)

      @address         = @address.sub(@pobox_pattern, '')
      @result[:number] = match && match[:pobox]
      @result[:street] = match && match[:number]
    end

    def extract_postcode
      match              = @postcode_pattern.match(@address)
      @address           = @address.sub(@postcode_pattern, '')
      @result[:postcode] = match && match[:postcode]
    end

    def extract_state
      @address = @address.sub(@state_pattern, ' ')
      @result[:state] = STATES.select { |s| s.include?(@state_match) }.flatten[0]
    end

    def extract_street_and_type
      street_match          = @street_pattern.match(@address)
      @address              = @address.sub(@street_pattern, '')
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
      @address         = @address.sub(@unit_and_number, '') if match

      @result[:unit]   = match[:unit] && match[:unit].sub('/', '').strip if match
      @result[:number] = match[:number] && match[:number].strip if match
    end

    private

    def check_if_address_is_dodgy
    end

    def has_pobox?
      @address =~ @pobox_pattern
    end

    protected

    def set_street_unit_number_pattern
      @street_type_match = STREET_TYPES.flatten.detect do |st|
        @street_pattern = Regexp.new(
          "(?:(?<unit_and_number>.*[\\d\\/]+[a-z]?)\\s)?((?<street>[A-z\\s]+)\\s+#{st})(?=(,|\\z))",
          Regexp::IGNORECASE
        )

        @address =~ @street_pattern
      end

      @street_pattern = nil unless @address =~ @street_pattern
    end

    def set_state_pattern
      @state_match = STATES.flatten.detect do |s|
        @state_pattern  = Regexp.new("\\s*#{s}\\s*", Regexp::IGNORECASE)
        @address       =~ @state_pattern
      end
    end
  end
end
