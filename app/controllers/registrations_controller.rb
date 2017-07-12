class RegistrationsController < Devise::RegistrationsController
  # http://blog.andrewray.me/how-to-set-up-devise-ajax-authentication-with-rails-4-0/
  # clear_respond_to // if you want the removal of static pages... user/sign_in
  #respond_to :json

  def new
    super
  end

  def create
    # add custom create logic here
    super
  end

  def update
    super
  end

end