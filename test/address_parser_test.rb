require 'test_helper'

class AddressParserBaseTest < Minitest::Test
  def test_should_extract_address
    puts AddressParser::Base.new('9/24-40 Springfield Avenue, Potts Point NSW 2011')
      .process_address

    puts '---'

    puts AddressParser::Base.new('7/329 Bondi Road, Bondi Beach NSW 2026')
      .process_address

    puts '---'

    puts AddressParser::Base.new('158-166 Day Street, Sydney NSW 2000')
      .process_address

    puts '---'

    puts AddressParser::Base.new('C203 Globe Street, Sydney NSW 2000')
      .process_address

    puts '---'

    puts AddressParser::Base.new('Globe street QLD 2000')
      .process_address

    puts '---'

    puts AddressParser::Base.new('SYDNEY victoria 2000')
      .process_address

    puts '---'

    puts AddressParser::Base.new('Shop 1 82 Elizabeth Street, Sydney NSW 2000')
      .process_address

    puts '---'

    puts AddressParser::Base.new('2 BOND STREET, SYDNEY 2000')
      .process_address

    puts '---'

    puts AddressParser::Base.new('Some street, NSW ')
      .process_address
  end
end
