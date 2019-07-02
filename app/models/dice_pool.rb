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
  DNR_SEQUENCE = "#{27.chr}d"

  define_attribute_methods :roller, :dice, :purpose, :result
  attr_accessor :roller, :dice, :purpose
  attr_reader :result

  validates :roller, presence: true, length: {
    in: 2...10,
    message: 'Must have a roller name (Maximum: 10).'
  }
  validates :dice, allow_nil: false, length: {
    minimum: 1, message: 'Must have dice to roll.'
  }
  validates :purpose, presence: true, length: {
    in: 2...300,
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
    {
      roller: roller, purpose: purpose, dice: dice.transform_keys(&:name)
    }.to_json
  end

  def attributes=(hash)
    hash.symbolize_keys!

    if hash[:dice]
      hash[:dice] = hash.delete(:dice).transform_keys do |die_name|
        Die.find_by(name: die_name)
      end
    end

    hash.each do |key, value|
      send("#{key}=", value)
    end
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
    # DicePoolBroadcastJob.perform_later result_json

    result
  end

  def result_json
    return nil unless result

    {
      roller: roller,
      purpose: purpose,
      dice: cookie_dice,
      result: cookie_result
    }
  end

  def view_dice
    dice.transform_keys(&:name).stringify_keys.to_json
  end

  def view_dice=(view_dice_s)
    return if view_dice_s.blank?

    self.dice = JSON.parse(view_dice_s).transform_keys! do |die_name|
      Die.find_by(name: die_name.to_sym)
    end
  end

  def cookie_result
    result.stringify_keys.to_json
  end

  def cookie_dice
    LogHandler::Debug.log_dice_results dice
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
