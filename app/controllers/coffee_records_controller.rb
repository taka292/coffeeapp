class CoffeeRecordsController < ApplicationController
  before_action :authenticate_user!

  def new
    @coffee_record = current_user.coffee_records.new
  end

  def create
    @coffee_record = current_user.coffee_records.new(coffee_record_params)

    if @coffee_record.save
      redirect_to records_path, notice: "抽出記録を保存しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def coffee_record_params
    params.require(:coffee_record).permit(
      :bean_name,
      :grind_size,
      :bean_amount,
      :water_temperature,
      :water_amount,
      :brew_memo,
      :brew_minute,
      :brew_second
    )
  end
end
