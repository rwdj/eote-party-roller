class DicePoolsController < ApplicationController
  class << self
    RENDER_TEMPLATE_MATCH = /^render_(\w*)_template$/.freeze

    def method_missing(name, *args, &block)
      if (template = fetch_template(name))
        return template
      end

      super
    end

    def fetch_template(name)
      if name.to_s.match(RENDER_TEMPLATE_MATCH)
        return render partial: "templates/#{Regexp.last_match(1)}"
      end

      false
    rescue ActionView::MissingTemplate
      false
    end

    def respond_to_missing?(method, *)
      method.to_s.match?(RENDER_TEMPLATE_MATCH) || super
    end
  end


  # GET /index
  def index
    @dice_pool = fetch_dice_pool

    render layout: 'index'
  end

  # GET /gm
  alias gm_index index

  # POST /index
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

  # Never trust parameters; only allow the white list.
  def dice_pool_params
    params.require(:dice_pool)
          .permit(:roller, :purpose, :result, :rolled, :json_dice)
  end

  def handle_roll
    @dice_pool.validate!
    @dice_pool.roll

    render json: {
      pool: @dice_pool.json_pool_results,
      dice: @dice_pool.json_dice_results
    }
  rescue ActiveModel::ValidationError
    render json: { message: @dice_pool.errors.values.flatten.join(' ') },
           status: 422
  end
end
