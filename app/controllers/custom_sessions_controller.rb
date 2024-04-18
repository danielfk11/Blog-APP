class CustomSessionsController < Devise::SessionsController
  def new
    redirect_to login_path
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
