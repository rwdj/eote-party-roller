require 'test_helper'

class DicePoolTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  setup do
    @model = DicePool.new
  end

  test 'Initialize' do
    sides = [side_types(:blank), *side_types]
    dice = [Die.new(sides: sides)]
    dice_pool = DicePool.new(dice: dice)
    assert(
      dice_pool.valid?,
      "Unable to initialize: #{dice_pool.errors.messages}"
    )
  end

  test 'Defaults: Name' do
    sides = [side_types(:blank), *side_types]
    dice = [Die.new(sides: sides)]
    dice_pool = DicePool.new(dice: dice)

    dice_pool.roller = 'i'
    assert_not dice_pool.valid?, 'Name too short'
    dice_pool.roller = 'i' * 11
    assert_not dice_pool.valid?, 'Name too long'
    dice_pool.roller = 'i' * 10
    assert_not dice_pool.valid?, 'Name limit is excluded'
    dice_pool.roller = 'ii'
    assert dice_pool.valid?, 'Name just right'
  end

  test 'Defaults: Purpose' do
    sides = [side_types(:blank), *side_types]
    dice = [Die.new(sides: sides)]
    dice_pool = DicePool.new(dice: dice)

    dice_pool.purpose = 'i'
    assert_not dice_pool.valid?, 'Purpose too short'
    dice_pool.purpose = 'i' * 301
    assert_not dice_pool.valid?, 'Purpose too long'
    dice_pool.purpose = 'i' * 300
    assert_not dice_pool.valid?, 'Purpose limit excluded'
    dice_pool.purpose = 'ii'
    assert dice_pool.valid?, 'Purpose just right'
  end

  test 'Sum result' do
    sides = [side_types(:blank), *side_types]
    die = Die.new(sides: sides)
    rolled_dice = { die => [die.roll, die.roll, die.roll] }
    assert_equal rolled_dice[die].sum.finalize,
                 DicePool.new(dice: rolled_dice).send(:sum_result)


  end
end
