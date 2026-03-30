class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      if resource.persisted?
        set_flash_message!(:notice, :signed_in_with_name, name: resource.name)
      end
    end
  end
end
