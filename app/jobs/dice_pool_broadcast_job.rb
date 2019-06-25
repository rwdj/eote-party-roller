class DicePoolBroadcastJob < ApplicationJob
  DNR_PURPOSE = /^dnr:?/i
  MAX_PURPOSE_DISPLAY_LENGTH = 4

  queue_as :default

  def perform(dice_pool_hash)
    dice_pool_hash[:purpose] = purpose_html(dice_pool_hash)
    ActionCable.server.broadcast 'dice_pools', dice_pool_hash
  end

  private

  def purpose_html(dice_pool_hash)
    dice_pool_hash[:purpose].strip!
    [
      parse_dnr_purpose(dice_pool_hash),
      '<div class="tooltip">',
      parse_purpose(dice_pool_hash[:purpose]),
      '<span class="tooltiptext">',
      dice_pool_hash[:purpose],
      '</span></div>'
    ].join
  end

  def parse_purpose(purpose)
    return purpose if purpose.length <= MAX_PURPOSE_DISPLAY_LENGTH

    "#{purpose[0...MAX_PURPOSE_DISPLAY_LENGTH]}…"
  end

  def parse_dnr_purpose(dice_pool_hash)
    if dice_pool_hash[:purpose].match?(DNR_PURPOSE)
      dice_pool_hash[:purpose].sub!(DNR_PURPOSE, '')
      dice_pool_hash[:purpose].lstrip!
      return DicePool::DNR_SEQUENCE
    end

    ''
  end
end
