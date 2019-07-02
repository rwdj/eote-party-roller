class DicePoolsController < ApplicationController
  class << self
    RENDER_TEMPLATE_MATCH = /^render_(\w*)_template$/.freeze

    def render_result(result)
      LogHandler::Debug.log 'Debugging render_result'
      render partial: 'results', locals: { results: result }
    end

    def render_dice(dice)
      LogHandler::Debug.log 'Debugging render_dice'
      render partial: 'dice_results', locals: { dice: dice }
    end

    def method_missing(name, *args, &block)
      if (template = fetch_template(name))
        return template
      end

      super
    end

    def fetch_template(name)
      if name.to_s.match(RENDER_TEMPLATE_MATCH)
        return render partial: Regexp.last_match(1)
      end

      false
    rescue ActionView::MissingTemplate
      false
    end

    def respond_to_missing?(method, *)
      method.match?(RENDER_TEMPLATE_MATCH) || super
    end
  end

  # GET /roller
  def roller
    LogHandler::Info.log 'Getting roller'

    @dice_pool = fetch_dice_pool
    @result = { pool: fetch_roll_result, dice: fetch_roll_dice }

    render layout: 'roller'
  end

  # POST /roller
  def roll
    @dice_pool = DicePool.new(dice_pool_params)
    cookies[:dice_pool] = @dice_pool.as_json

    handle_roll
  end

  private

  def fetch_dice_pool
    return DicePool.new unless cookies[:dice_pool].present?

    DicePool.new.from_json(cookies[:dice_pool])
  end

  def fetch_roll_result
    return nil unless cookies[:result].present?

    result = JSON.parse(cookies[:result])
    self.class.render_result(result)
  end

  def fetch_roll_dice
    return nil unless cookies[:dice].present?

    dice = JSON.parse(cookies[:dice])
    self.class.render_dice(dice)
  end

  # Never trust parameters; only allow the white list.
  def dice_pool_params
    params.require(:dice_pool)
          .permit(:roller, :purpose, :result, :rolled, :view_dice)
  end

  def handle_roll
    @dice_pool.validate!

    @dice_pool.roll
    save_roll

    render json: { result: cookies[:result], dice: cookies[:dice] }
  rescue ActiveModel::ValidationError
    render json: { message: @dice_pool.errors.values.flatten.join(' ') },
           status: 422
  end

  def save_roll
    cookies[:result] = @dice_pool.cookie_result
    cookies[:dice] = @dice_pool.cookie_dice
  end
end
