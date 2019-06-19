# frozen_string_literal: true

# Holds values
class ResultTypes
  GOOD = %i[success advantage triumph light].freeze
  BAD = %i[failure threat despair dark].freeze

  ALL = [*GOOD.each_index.map { |i| [GOOD[i], BAD[i]] }].flatten.freeze

  class << self
    private

    def sort(values)
      values.sort_by! { |value| ALL.index(value) }
    end
  end

  PAIRS = GOOD.zip(BAD)
  FATE = sort([GOOD.last, BAD.last]).freeze
  DATA = sort([*GOOD, *BAD[2..]]).freeze
  EXCEPTIONALS = { GOOD.first => { GOOD[2] => 1, BAD[2] => -1 } }.freeze
  BINARY = [GOOD[2], BAD[2]].freeze
  NEGATING_PAIRS = [*[0, 1].map { |i| [GOOD[i], BAD[i]] }].freeze
  NEGATING = NEGATING_PAIRS.map { |pair| pair[1] }.freeze
  NON_NEGATING =
    ALL.reject { |type| NEGATING_PAIRS.flatten.include? type }.freeze
  LONELY = sort([*GOOD[2..], *BAD[2..]]).freeze
  POSITIVE = LONELY
end
