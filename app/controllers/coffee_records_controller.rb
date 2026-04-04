class CoffeeRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :discard_coffee_record_wizard_session, only: [:new, :index]

  WIZARD_STEP1_PARAM_KEYS = %i[
    bean_name
    grind_size
    bean_amount
    water_temperature
    water_amount
    brew_memo
    brew_minute
    brew_second
  ].freeze

  def index
    @coffee_records = current_user.coffee_records.order(created_at: :desc)
  end

  def new
    @coffee_record = current_user.coffee_records.new
  end

  def create
    @coffee_record = current_user.coffee_records.new(coffee_record_params)

    if @coffee_record.valid?
      session[:coffee_record_wizard] = coffee_record_params.to_h.stringify_keys
      redirect_to coffee_records_taste_path, notice: "味の記録に進みましょう。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def taste
    wizard = session[:coffee_record_wizard]
    unless wizard.present?
      redirect_to new_coffee_record_path, alert: "先に抽出条件を入力してください。"
      return
    end

    @coffee_record = build_coffee_record_from_wizard(wizard)
  end

  def taste_create
    wizard = session[:coffee_record_wizard]
    unless wizard.present?
      redirect_to new_coffee_record_path, alert: "先に抽出条件を入力してください。"
      return
    end

    merged = wizard.stringify_keys.merge(taste_params.to_h.stringify_keys)
    @coffee_record = current_user.coffee_records.new(merged)

    if @coffee_record.save
      session.delete(:coffee_record_wizard)
      redirect_to coffee_records_path, notice: "コーヒー記録を保存しました。"
    else
      render :taste, status: :unprocessable_entity
    end
  end

  private

  def coffee_record_params
    params.require(:coffee_record).permit(*WIZARD_STEP1_PARAM_KEYS)
  end

  def taste_params
    params.require(:coffee_record).permit(:acidity, :bitterness, :sweetness, :body, :off_flavor, :comment)
  end

  def build_coffee_record_from_wizard(wizard_hash)
      attrs = wizard_hash.stringify_keys.slice(*WIZARD_STEP1_PARAM_KEYS.map(&:to_s))
    current_user.coffee_records.new(attrs)
  end
end
