require 'test_helper'

class TestAddressParser < Minitest::Test
  def test_things
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

  def test_another_thing
    address = AddressParser::Base.new('Dodgy address')
      .process_address

    puts address
  end
end
