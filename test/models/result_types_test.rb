require 'test_helper'

class ResultTypesTest < ActiveSupport::TestCase
  test 'GOOD' do
    assert_equal ResultTypes::GOOD, %i[success advantage triumph light]
  end

  test 'BAD' do
    assert_equal %i[failure threat despair dark], ResultTypes::BAD
  end

  test 'ALL' do
    assert_equal %i[
      success failure advantage threat
      triumph despair light dark
    ], ResultTypes::ALL
  end

  test 'PAIRS' do
    assert_equal [
      %i[success failure],
      %i[advantage threat],
      %i[triumph despair],
      %i[light dark],
    ], ResultTypes::PAIRS
  end

  test 'FATE' do
    assert_equal %i[light dark], ResultTypes::FATE
  end

  test 'DATA' do
    assert_equal %i[success advantage triumph despair light dark],
                 ResultTypes::DATA
  end

  test 'EXCEPTIONAL' do
    assert_equal({ success: { triumph: 1, despair: -1 } },
                 ResultTypes::EXCEPTIONALS)
  end

  test 'BINARY' do
    assert_equal %i[triumph despair], ResultTypes::BINARY
  end

  test 'NEGATING_PAIRS' do
    assert_equal [%i[success failure], %i[advantage threat]],
                 ResultTypes::NEGATING_PAIRS
  end

  test 'NEGATING' do
    assert_equal %i[failure threat], ResultTypes::NEGATING
  end

  test 'NON_NEGATING' do
    assert_equal %i[triumph despair light dark], ResultTypes::NON_NEGATING
  end

  test 'LONELY' do
    assert_equal %i[triumph despair light dark], ResultTypes::LONELY
  end
end
