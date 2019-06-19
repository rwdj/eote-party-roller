require 'test_helper'

class SideTypeTest < ActiveSupport::TestCase
  test 'Initiates' do
    assert side_types(:blank).valid?, side_types(:blank).errors.messages

    assert side_types(:s2).valid?, side_types(:s2).errors.messages
  end

  test 'Equal instances' do
    assert_equal side_types(:blank), SideType.new, 'Unequal blank dice'
    assert_equal side_types(:s2), SideType.new(success: 2),
                 'Unequal (s: 2) dice'
  end

  test 'No duplicates' do
    SideType.create
    assert_not SideType.new.valid?, 'Allowed duplicate blank'

    SideType.create(success: 2)
    assert_not SideType.new(success: 2).valid?, 'Allowed duplicate (s: 1)'
  end

  test 'MD5 Keys' do
    assert_equal '99914b932bd37a50b983c5e7c90ae93b',
                 side_types(:blank).send(:generate_md5_hash)
    assert_equal 'c03a5e07636e17664ab7745acaac0c3b',
                 side_types(:s1).send(:generate_md5_hash)
  end

  test 'Sort Results' do
    assert_equal({}, side_types(:blank).send(:sort_results, {}),
                 'Failed sort (blank)')
    assert_equal({ success: 1, triumph: 2 },
                 side_types(:blank).send(:sort_results, triumph: 2, success: 1),
                 'Failed sort (s: 1 tr: 2)')
    given = %i[
      despair dark threat triumph light success failure advantage
    ].map { |type| [type, 1] }.to_h
    expected = ResultTypes::ALL.map { |type| [type, 1] }
    assert_equal(expected, side_types(:blank).send(:sort_results, given).to_a,
                 'Failed sort (complex all)')
  end

  test 'Lonely Values are Lonely' do
    assert_not(
      SideType.new(triumph: 1, despair: 1).valid?, 'Allowed triumph and despair'
    )
    assert_not(
      SideType.new(light: 1, dark: 1).valid?, 'Allowed light and dark'
    )
  end

  test 'Non-Negating Values are Positive' do
    ResultTypes::NON_NEGATING.each do |result_type|
      assert SideType.new(result_type => 1).valid?,
             "#{result_type} wasn't allowed a 1 value"
      assert SideType.new(result_type => 0).valid?,
             "#{result_type} wasn't allowed a 0 value"
      assert_not SideType.new(result_type => -1).valid?,
                 "#{result_type} wasn't allowed a -1 value"
    end
  end

  test 'Binary Values are Binary' do
    ResultTypes::BINARY.each do |result_type|
      assert_not SideType.new(result_type => 2).valid?,
                 "#{result_type} was allowed a 2 value"
      assert SideType.new(result_type => 1).valid?,
             "#{result_type} wasn't allowed a 1 value"
      assert SideType.new(result_type => 0).valid?,
             "#{result_type} wasn't allowed a 0 value"
      assert_not SideType.new(result_type => -1).valid?,
                 "#{result_type} allowed a -1 value"
    end
  end

  test 'Not initiated values are zero' do
    ResultTypes::ALL.each do |result_type|
      assert_equal 0, side_types(:blank).send(result_type)
    end
  end

  test 'Not initiated values not in results' do
    assert_nil side_types(:blank).results[:advantage]
  end

  test 'Storing Negative Values' do
    assert_equal -2, SideType.new(failure: 2).results[:success],
                 'Negative result (f: 2) stored incorrectly'
    assert_equal -2, SideType.new(success: -2).results[:success],
                 'Negative result (s: -2) stored incorrect;y'
    assert SideType.new(failure: 2).valid?, 'Negative result (f: 2) invalid'
    assert SideType.new(success: -2).valid?, 'Negative result (s: -2) invalid'
    assert SideType.new(threat: 2).valid?, 'Negative result (t: 2) invalid'
    assert SideType.new(advantage: -2).valid?, 'Negative result (a: -2) invalid'
  end

  test 'Summing SideTypes' do
    assert_equal side_types(:s2a2), side_types(:s2) + side_types(:a2),
                 'Failed to sum (s: 2) and (a: 2)'
    assert_equal side_types(:s4a4), side_types(:s2a2) + side_types(:s2a2),
                 'Failed to sum (s: 2, a: 2) with itself'
    assert_equal side_types(:f2t2), side_types(:s2a2) + side_types(:f4t4),
                 'Failed to sum (s: 2, a: 2) and (f: 4, t: 4)'
  end

  test 'Finalize exceptional results' do
    assert_equal(
      {}, side_types(:blank).send(:finalize_exceptional_results!, {}),
      'Incorrect finalize excpetional result without execeptional (blank)'
    )
    assert_equal(
      { success: 2 },
      side_types(:blank).send(:finalize_exceptional_results!, success: 2),
      'Incorrect finalize excpetional result without execeptional (s: 2)'
    )
    test_cond = { success: 1, despair: 1 }
    assert_equal(
      { success: 0, despair: 1 },
      side_types(:blank).send(:finalize_exceptional_results!, test_cond),
      'Incorrect finalize excpetional result (s: 1 de: 1)'
    )
    test_cond = { success: 1, triumph: 2 }
    assert_equal(
      { success: 3, triumph: 2 },
      side_types(:blank).send(:finalize_exceptional_results!, test_cond),
      'Incorrect finalize excpetional result (s: 1 tr: 1)'
    )
    test_cond = { light: 2, dark: 2 }
    assert_equal(
      { light: 2, dark: 2 },
      side_types(:blank).send(:finalize_exceptional_results!, test_cond),
      'Incorrect finalize excpetional result (li: 2, da: 2)'
    )
  end

  test 'Finalize negating results' do
    assert_equal(
      {}, side_types(:blank).send(:finalize_negating_results!, {}),
      'Incorrect finalize negate result (blank)'
    )
    assert_equal(
      { success: 2 },
      side_types(:blank).send(:finalize_negating_results!, success: 2),
      'Incorrect finalize negate result (s: 2)'
    )
    assert_equal(
      { failure: 2 },
      side_types(:blank).send(:finalize_negating_results!, success: -2),
      'Incorrect finalize negate result (s: -2)'
    )
    test_cond = { success: -1, despair: 1 }
    assert_equal(
      { failure: 1, despair: 1 },
      side_types(:blank).send(:finalize_negating_results!, test_cond),
      'Incorrect finalize negate result (s: -1 de: 1)'
    )
  end

  test 'Finalize only one failure' do
    assert_equal(
      {}, side_types(:blank).send(:finalize_only_one_failure!, {}),
      'Incorrect finalize only one failure (blank)'
    )
    assert_equal(
      { success: 2 },
      side_types(:blank).send(:finalize_only_one_failure!, {success: 2}),
      'Incorrect finalize only one failure (s: 2)'
    )
    assert_equal(
      { failure: 1 },
      side_types(:blank).send(:finalize_only_one_failure!, failure: 1),
      'Incorrect finalize only one failure (f: 1)'
    )
    assert_equal(
      { failure: 1 },
      side_types(:blank).send(:finalize_only_one_failure!, failure: 2),
      'Incorrect finalize only one failure (f: 2)'
    )
  end

  test 'Finalize' do
    assert_equal({}, side_types(:blank).finalize, 'Incorrect finalize blank')
    assert_equal(
      { success: 2 }, side_types(:s2).finalize, 'Incorrect finalize (s: 2)'
    )
    assert_equal(
      { failure: 1 }, side_types(:f1).finalize, 'Incorrect finalize (f: 1)'
    )
    assert_equal(
      { failure: 1 }, side_types(:f2).finalize,
      'Incorrect finalize (f: 2): max 1 failure'
    )
    assert_equal(
      { failure: 1, threat: 2}, side_types(:f2t2).finalize,
      'Incorrect finalize (f: 2): max 1 failure missing attrs'
    )
    assert_equal(
      { threat: 2 }, side_types(:t2).finalize, 'Incorrect finalize (t: 2)'
    )
    assert_equal(
      { despair: 1 }, side_types(:s1de1).finalize,
      'Incorrect finalize (s: 1, de: 1): subtract a success'
    )
    assert_equal(
      { success: 1, despair: 1 }, side_types(:s2de1).finalize,
      'Incorrect finalize (s: 2, de: 1)'
    )
    assert_equal(
      { light: 2, dark: 2 }, side_types(:li2da2).finalize,
      "Incorrect finalize (li: 2, da: 2): light and dark don't negate"
    )
  end
end
