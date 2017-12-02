class RegistrationsController < Devise::RegistrationsController
  # http://blog.andrewray.me/how-to-set-up-devise-ajax-authentication-with-rails-4-0/
  # clear_respond_to # if you want the removal of static pages... user/sign_in
  # respond_to :json

  # skip_before_filter :verify_authenticity_token

  before_action :set_variables, only: :new
  before_action :update_sign_up_params, only: :create

  REGISTRATION_STEPS = %w(key_details description confirmation)

  def new
    super { |resource| resource.assign_attributes(sign_up_params) }
  end

  def create
    build_resource(sign_up_params)

    return previous_step if params[:previous_button]
    return next_step unless session[:registration_step] == REGISTRATION_STEPS.last

    resource.avatar = retrieve_cached_avatar
    resource.save

    if resource.persisted?
      resource.destroy! unless resource.add_other_information further_params
    end

    devise_create_procedure
  end

  def update
    super
  end

  private

  def set_variables
    @skills ||= Skill.all.pluck(:name).map { |x| x.titleize }
    @subjects ||= Subject.all.pluck(:name).map { |x| x.titleize }
    @involvements ||= Involvement::STATIC_INVOLVEMENTS.map { |x| x.titleize }

    session[:sign_up_params] ||= {}
    session[:registration_step] ||= REGISTRATION_STEPS[0]
  end

  def update_sign_up_params
    return unless params[:user]
    session[:sign_up_params].deep_merge!(params[:user].except(:avatar))
    upload_avatar unless params[:user][:avatar]
  end

  def clean_up
    session[:sign_up_params] = session[:registration_step] = nil
    CarrierWave.clean_cached_files!
  end

  def previous_step
    unless session[:registration_step] == REGISTRATION_STEPS.first
      session[:registration_step] = REGISTRATION_STEPS[current_step_index - 1]
    end
    redirect_to :new_user_registration
  end

  def next_step
    session[:registration_step] = REGISTRATION_STEPS[current_step_index + 1]
    redirect_to :new_user_registration
  end

  def current_step_index
    REGISTRATION_STEPS.index(session[:registration_step])
  end

  # params that cannot be used on user creation
  def further_params
    session[:sign_up_params].symbolize_keys.slice(:involvements, :subjects,
      :skills, :other_interests).tap do |alt_param|
        if alt_param[:other_interests]
          alt_param[:other_interests] = alt_param[:other_interests].split(',')
        end
      end
  end

  # DEVISE OVERRIDEN METHODS
  # devise-4.3.0/app/controllers/devise/registrations_controller.rb

  # override devise's :sign_up_params grabbing session data instead
  def sign_up_params
    session[:sign_up_params].symbolize_keys.slice(
      :email, :password, :password_confirmation, :name, :social,
      :address_line1, :address_line2, :address_line3, :locality, :post_code,
      :country, :bio, :lonlat
    )
  end

  def devise_create_procedure
    if resource.persisted?
      clean_up # added!
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # AVATAR UPLOAD
  def cache_avatar
    session[:uploader_cache_id] = avatar_uploader.cache_id
    avatar_uploader.cache! params[:user][:avatar]
    session[:sign_up_params][:avatar_cache] = avatar_uploader.cache_name
  end

  def retrieve_cached_avatar
    avatar_uploader.retrieve_from_cache! session[:sign_up_params][:avatar_cache]
    avatar_uploader
  end

  def avatar_uploader
    @uploader ||= AvatarUploader.new
    @uploader.cache_id = session[:uploader_cache_id] if session[:uploader_cache_id]
    @uploader
  end

end
