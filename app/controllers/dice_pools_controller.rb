class DicePoolsController < ApplicationController
  class << self
    def render_result(result)
      LogHandler::Debug.log 'Debugging render_result'
      render partial: 'result', locals: { results: result }
    end

    def render_dice(dice)
      LogHandler::Debug.log 'Debugging render_dice'
      render partial: 'dice', locals: { dice: dice }
    end
  end

  # GET /rolls
  def index
    render layout: 'index'
  end

  # GET /roller
  def roller
    LogHandler::Info.log 'Getting roller'

    @dice_pool = fetch_dice_pool
    @result = fetch_roll_result
    @dice = fetch_roll_dice

    LogHandler::Debug.log_dice_pool @dice_pool
    LogHandler::Debug.log_dice @dice_pool.dice
    render layout: 'roller'
  end

  # POST /roller
  def roll
    LogHandler::Info.log 'Rolling'

    LogHandler::Debug.log_params dice_pool_params
    LogHandler::Debug.log_dice_pool @dice_pool = DicePool.new(dice_pool_params)
    LogHandler::Debug.log_dice_pool_cookie(
      cookies[:dice_pool] = @dice_pool.as_json
    )

    handle_roll
  end

  private

  def fetch_dice_pool
    LogHandler::Info.log 'Fetching Dice Pool'
    return DicePool.new unless cookies[:dice_pool].present?

    LogHandler::Debug.log_dice_pool_cookie cookies[:dice_pool]
    dice_pool = DicePool.new.from_json(cookies[:dice_pool])
  ensure
    LogHandler::Debug.log_parsed_dice_pool_cookie dice_pool
  end

  def fetch_roll_result
    return nil unless cookies[:result].present?

    result = JSON.parse(cookies[:result])
    self.class.render_result(result)
  ensure
    LogHandler::Debug.log_result_cookie cookies[:result]
    LogHandler::Debug.log_parsed_result_cookie result
  end

  def fetch_roll_dice
    return nil unless cookies[:dice].present?

    dice = JSON.parse(cookies[:dice])
    self.class.render_dice(dice)
  ensure
    LogHandler::Debug.log_dice_cookie cookies[:dice]
    LogHandler::Debug.log_parsed_cookie_dice dice
  end

  # Never trust parameters; only allow the white list.
  def dice_pool_params
    params.require(:dice_pool)
          .permit(:roller, :purpose, :result, :rolled, :view_dice)
  end

  def handle_roll
    @dice_pool.validate!

    LogHandler::Info.log 'Rolling...'
    @dice_pool.roll
    save_roll
    redirect_to(roller_path)
  rescue ActiveRecord::RecordInvalid
    LogHandler::Debug.log_invalid_dice_pool @dice_pool.errors.to_s
    redirect_to(roller_path, notice: @dice_pool.errors)
  end

  def save_roll
    cookies[:result] = @dice_pool.cookie_result
    cookies[:dice] = @dice_pool.cookie_dice
  ensure
    LogHandler::Debug.log_set_result_cookie cookies[:result]
    LogHandler::Debug.log_set_dice_cookie cookies[:dice]
  end
end
