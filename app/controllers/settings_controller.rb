class SettingsController < ApplicationController
  before_action :discard_coffee_record_wizard_session, only: [:index]

  def index
  end
end
