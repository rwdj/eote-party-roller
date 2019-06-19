# frozen_string_literal: true

class DieTypes < ApplicationRecord
  GOOD = %i[ability proficiency boost].freeze
  BAD = %i[difficulty challenge setback].freeze
  FATE = %i[fate].freeze

  ALL = (GOOD.zip(BAD).flatten + FATE).freeze

  PAIRS = GOOD.zip(BAD).push([*FATE, nil]).freeze
  REPOSITIONED = %i[ability proficiency fate].freeze
end
