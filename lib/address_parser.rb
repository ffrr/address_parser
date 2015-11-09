require 'address_parser/version'
require 'address_parser/states'
require 'address_parser/street_types'
require 'address_parser/exceptions'

module AddressParser

  def self.new(address)
    Base.new(address)
  end

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
      @pobox_pattern       = %r{(?<pobox>p[.\s]?\s?o[.\s]?\s*box)\s(?<number>[\w\s]{1,6})}i
      @postcode_pattern    = %r{\s?(?<postcode>(?:[2-7]\d{3}|08\d{2}))$}
      @unit_number_pattern = %r{((?<unit>.*)(?<=[\/|\s])+)?(?<number>[a-z\d-]*)$}i

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

      @result
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
          "(?:(?<unit_and_number>.*[\\d\\/]+[a-z]?)\\s)?((?<street>[A-z\\s]+)\\s+#{st})(?=(,|\\z))",
          Regexp::IGNORECASE
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
