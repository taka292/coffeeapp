class CoffeeRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_last_coffee_record, only: [:new, :taste]
  before_action :discard_coffee_record_wizard_session, only: [:new, :index, :edit, :edit_taste, :update_brew, :update_taste]
  before_action :set_coffee_record, only: %i[edit update_brew edit_taste update_taste destroy]

  WIZARD_STEP1_PARAM_KEYS = %i[
    bean_name
    grind_size
    bean_amount
    water_temperature
    water_amount
    brew_memo
    brew_time
  ].freeze

  def index
    @coffee_records = current_user.coffee_records.order(created_at: :desc)
  end

  def new
    @coffee_record = if @last_coffee_record
                       current_user.coffee_records.new(brew_attributes_from_record(@last_coffee_record))
                     else
                       current_user.coffee_records.new
                     end
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

  def edit
  end

  def update_brew
    @coffee_record.assign_attributes(coffee_record_params)
    if @coffee_record.has_changes_to_save?
      if @coffee_record.save
        redirect_to edit_taste_coffee_record_path(@coffee_record), notice: "抽出条件を保存しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to edit_taste_coffee_record_path(@coffee_record)
    end
  end

  def edit_taste
  end

  def update_taste
    @coffee_record.assign_attributes(taste_params)
    if @coffee_record.has_changes_to_save?
      if @coffee_record.save
        redirect_to coffee_records_path, notice: "味の記録を保存しました。"
      else
        render :edit_taste, status: :unprocessable_entity
      end
    else
      redirect_to coffee_records_path,
                  notice: "編集しました"
    end
  end

  def destroy
    @coffee_record.destroy
    redirect_to coffee_records_path, notice: "記録を削除しました。"
  end

  def taste
    wizard = session[:coffee_record_wizard]
    unless wizard.present?
      redirect_to new_coffee_record_path, alert: "先に抽出条件を入力してください。"
      return
    end

    @coffee_record = build_coffee_record_from_wizard(wizard)
    apply_taste_seed_from_last_saved(@coffee_record)
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

  def set_coffee_record
    @coffee_record = current_user.coffee_records.find(params[:id])
  end

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

  def brew_attributes_from_record(record)
    {
      bean_name: record.bean_name,
      grind_size: record.grind_size,
      bean_amount: record.bean_amount,
      water_temperature: record.water_temperature,
      water_amount: record.water_amount,
      brew_memo: record.brew_memo,
      brew_time: record.brew_time
    }
  end

  def apply_taste_seed_from_last_saved(record)
    return if @last_coffee_record.nil?

    last = @last_coffee_record
    record.acidity = last.acidity if record.acidity.nil?
    record.bitterness = last.bitterness if record.bitterness.nil?
    record.sweetness = last.sweetness if record.sweetness.nil?
    record.body = last.body if record.body.nil?
    record.off_flavor = last.off_flavor if record.off_flavor.nil?
    record.comment = last.comment if record.comment.blank?
  end

  def set_last_coffee_record
    @last_coffee_record = current_user.coffee_records.recent.first
  end
end
