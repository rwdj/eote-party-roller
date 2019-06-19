require 'test_helper'

class DieTest < ActiveSupport::TestCase
  test 'Initialize' do
    sides = [side_types(:blank), *side_types]
    assert Die.create(name: Die::DEFAULT_NAME, sides: sides),
           'Failed to initiate die'
  end

  test 'Default name' do
    assert_equal Die::DEFAULT_NAME, Die.new.name,
                 'Die failed to initiate default name'
    sides = [side_types(:blank), *side_types]
    assert Die.new(sides: sides).valid?,
           'Default name invalid'
  end

  test 'Other Names' do
    sides = [side_types(:blank), *side_types]
    DieTypes::ALL.each do |die_type|
      assert(
        Die.new(name: die_type, sides: sides).valid?,
        "Initiate symbol name #{die_type}"
      )
    end
  end

  test 'Require sides' do
    assert_not Die.new(name: Die::DEFAULT_NAME).valid?,
               'cannot have nil sides'
    assert_not Die.new(name: Die::DEFAULT_NAME, sides: []).valid?,
               'cannot have empty sides'
    die = Die.new(name: Die::DEFAULT_NAME, sides: [side_types(:blank)])
    assert die.valid?, "can have 1 side: #{die.errors.messages}"
  end

  test 'Sides input and output correctly' do
    die = Die.new
    sides = [side_types(:blank), *side_types]
    die.sides = sides
    assert_equal sides.map(&:id), die.read_attribute(:sides),
                 'Sides not stored correctly'
    assert_equal sides, die.sides, 'Sides not output correctly'
  end
end
