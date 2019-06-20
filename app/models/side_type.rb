# frozen_string_literal: true

# Models the possible sides of dice
class SideType < ApplicationRecord
  include Comparable

  validates :md5_hash, presence: true, uniqueness: true
  ResultTypes::BINARY.each do |binary_attr|
    validates binary_attr, numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 1,
      message: "#{binary_attr} not binary"
    }
  end
  ResultTypes::DATA.each do |result_type|
    validates result_type, numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 2,
      message: "#{result_type} not positive"
    }
  end

  after_initialize :no_str_results, :no_nil, :generate_md5_hash
  before_validation :lonely_values_are_lonely

  ResultTypes::NON_NEGATING.each do |result_type|
    define_method(result_type) { results[result_type] || 0 }
    define_method("#{result_type}=".to_sym) do |value|
      results[result_type] = value
    end
  end
  ResultTypes::NEGATING_PAIRS.each do |result_type_pos, result_type_neg|
    define_method(result_type_pos) do
      results[result_type_pos]&.positive? ? results[result_type_pos] : 0
    end
    define_method(result_type_neg) do
      results[result_type_neg]&.negative? ? -results[result_type_neg] : 0
    end
    define_method("#{result_type_pos}=".to_sym) do |value|
      results[result_type_pos] = value
    end
    define_method("#{result_type_neg}=".to_sym) do |value|
      results[result_type_pos] = -value
    end
  end

  class << self
    def find_by_results(params = {})
      find_by__prep_negative_params(params)
      find_by(md5_hash: generate_md5_hash(params))
    end

    def generate_md5_hash(results)
      Digest::MD5.hexdigest(sort_results(results).to_s)
    end

    def sort_results(results)
      results.to_a.sort do |a, b|
        ResultTypes::ALL.index(a[0]) <=> ResultTypes::ALL.index(b[0])
      end.to_h
    end

    private

    def find_by__prep_negative_params(params)
      ResultTypes::NEGATING_PAIRS.each do |result_type_pos, result_type_neg|
        if params[result_type_neg]
          params[result_type_pos] = -params.delete(result_type_neg)
        end
      end

      params
    end
  end

  def attributes=(hash)
    hash.symbolize_keys!

    unless hash[:results]
      self.results = {}
      ResultTypes::ALL.each do |result_type|
        results[result_type] = hash.delete(result_type)
      end
    end

    super hash
  end

  def to_s
    [
      "#<#{self.class}",
      finalize_negating_results!(sort_results(results.clone)).map do |pair|
        pair.join(': ')
      end.join(', ')
    ].reject(&:empty?).join(' ') + '>'
  end

  def <=>(other)
    return 0 if md5_hash.eql? other.md5_hash

    ResultTypes::DATA.each do |data_result_type|
      return case send(data_result_type) - other.send(data_result_type)
             when :negative? then -1
             when :positive? then 1
             end
    end
  end

  def +(other)
    SideType.new(
      results.merge(other.results) { |_, old_val, new_val| old_val + new_val }
    )
  end

  def finalize
    final_results = results.clone

    finalize_exceptional_results!(final_results)
    finalize_negating_results!(final_results)
    finalize_only_one_failure!(final_results)

    sort_results(final_results.reject { |_, value| value.zero? })
  end

  def displayable_results
    sort_results(finalize_negating_results!(results.clone))
  end

  private

  def finalize_exceptional_results!(final_results)
    ResultTypes::EXCEPTIONALS.each do |affected, exceptionals|
      exceptionals.each do |exceptional, effect|
        final_results[exceptional]&.times do
          final_results[affected] = (final_results[affected] || 0) + effect
        end
      end
    end

    final_results
  end

  def finalize_negating_results!(final_results)
    ResultTypes::NEGATING_PAIRS.each do |negated, negating|
      if final_results[negated]&.negative?
        final_results[negating] = -final_results.delete(negated)
      end
    end

    final_results
  end

  def finalize_only_one_failure!(final_results)
    final_results[:failure] = 1 if final_results[:failure]&.positive?

    final_results
  end

  def generate_md5_hash
    self.md5_hash = self.class.generate_md5_hash(sort_results(results))
  end

  def sort_results(results)
    self.class.sort_results(results)
  end

  def no_nil
    results.reject! { |_, val| val.zero? }
  end

  def no_str_results
    results.transform_keys!(&:to_sym)
  end

  def lonely_values_are_lonely
    lonely_keys = results.keys & ResultTypes::LONELY
    return unless lonely_keys.count > 1

    errors.add :results, "Bad Result Combination: #{lonely_keys}"
  end
end
