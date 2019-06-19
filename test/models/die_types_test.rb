require 'test_helper'

class DieTypesTest < ActiveSupport::TestCase
  test 'GOOD' do
    assert_equal %i[ability proficiency boost], DieTypes::GOOD
  end

  test 'BAD' do
    assert_equal %i[difficulty challenge setback], DieTypes::BAD
  end

  test 'FATE' do
    assert_equal %i[fate], DieTypes::FATE
  end

  test 'ALL' do
    assert_equal %i[
      ability difficulty proficiency challenge
      boost setback fate
    ], DieTypes::ALL
  end

  test 'PAIRS' do
    assert_equal [
      %i[ability difficulty],
      %i[proficiency challenge],
      %i[boost setback],
      [:fate, nil]
    ], DieTypes::PAIRS
  end
end
