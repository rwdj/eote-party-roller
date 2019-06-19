# frozen_string_literal: true

# Models a rollable die with sides
class Die < ApplicationRecord
  DEFAULT_NAME = 'default'

  validates :name, uniqueness: true
  validates :name, presence: true, inclusion: {
    in: DieTypes::ALL.map(&:to_s) + [DEFAULT_NAME],
    message: 'must have a valid die name to be rolled correctly -> %{value}'
  }
  validates :sides, presence: true, allow_blank: false

  after_initialize :set_default_name

  def to_s
    "#<Die #{name.humanize}>"
  end

  # Maps outputted side ids to sides
  def sides
    ActiveRecord::Base.logger.silence do
      super.map { |side_type_id| SideType.find(side_type_id) }
    end
  end

  # Maps inputted sides to side ids
  def sides=(new_sides)
    super new_sides.map(&:id)
  end

  # Selects a random side using a normalized [0, 1) pseudorandom probability
  def roll
    side_i = (rand(0.0...1) * sides.size).to_i
    sides.fetch(side_i)
  end

  private

  def set_default_name
    self.name ||= DEFAULT_NAME
  end
end
