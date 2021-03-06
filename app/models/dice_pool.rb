# frozen_string_literal: true

# Handles Results for rolls
class DicePool
  extend ActiveModel::Callbacks
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  include ActiveModel::Dirty
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  DEFAULT_ROLLER = 'Anon'
  DEFAULT_PURPOSE = 'N/A'
  DNR_SEQUENCE = /^dnr(?!\w):?\s*/i.freeze
  NAME_MAX_LENGTH = 10
  PURPOSE_MAX_LENGTH = 300

  define_attribute_methods :roller, :dice, :purpose, :result
  attr_accessor :roller, :dice, :purpose
  attr_reader :result

  validates :roller, presence: true, length: {
    in: 2...NAME_MAX_LENGTH,
    message: 'Must have a roller name (Maximum: 10).'
  }
  validates :dice, allow_nil: false, length: {
    minimum: 1, message: 'Must have dice to roll.'
  }
  validates :purpose, presence: true, length: {
    in: 2...PURPOSE_MAX_LENGTH,
    message: 'Must have a purpose (Maximum: 300).'
  }

  define_model_callbacks :initialize, only: :after
  after_initialize :set_default_values

  def initialize(attributes = nil)
    super(attributes)

    run_callbacks(:initialize) {}
  end

  def persisted?
    false
  end

  def id
    nil
  end

  def as_json
    { roller: roller, purpose: purpose, json_dice: json_dice }.to_json
  end

  def attributes=(hash)
    hash.symbolize_keys!

    hash.each { |key, value| send("#{key}=", value) }
  end

  # Gives a pretty readable string to print this instance
  def to_s
    "#<#{self.class} " +
      [
        "roller: #{roller}",
        "purpose: #{purpose[0..20]}",
        ("result: #{result}" if result),
        "dice: #{dice.transform_keys.map(&:to_s)}"
      ].reject(&:blank?).join(', ') + '>'
  end

  # Rolls the entire dice pool and tallies the result
  def roll
    return false unless valid?

    dice.each_key { |die| roll_die(die) }
    sum_result
    DicePoolBroadcastJob.perform_later result_json

    result
  end

  def result_json
    return nil unless result

    {
      roller: roller,
      purpose: purpose,
      results: {
        dice: json_dice_results,
        pool: json_pool_results
      }.to_json
    }
  end

  # Loads dice from a map of dice names to dice counts
  def json_dice=(dice_json)
    @dice = JSON.parse(dice_json).transform_keys do |die_name|
      Die.find_by(name: die_name.to_sym)
    end
  end

  # a map of dice names to dice counts
  def json_dice
    dice.transform_keys(&:name).to_json
  end

  def json_pool_results
    result.stringify_keys.to_json
  end

  def json_dice_results
    dice.map do |die, die_results|
      [die.name.to_s, die_results.map(&:displayable_results)]
    end.to_h.to_json
  end

  private

  attr_writer :result

  def roll_die(die)
    rolls = []
    dice[die].times do
      rolls << die.roll
    end

    dice[die] = rolls
  end

  def sum_result
    self.result = dice.values.flatten.sum.finalize
  end

  def update(params)
    params.each do |key, value|
      send("#{key}=", value)
    end
  end

  def set_default_values
    self.roller ||= 'Anon'
    self.purpose ||= 'N/A'
    self.dice ||= {}
  end
end
