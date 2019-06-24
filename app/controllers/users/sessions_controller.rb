# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    @user = User.find_by_name(params[:user][:name])
    @errors = ""
    if @user.present?
      password = params[:user][:password]
      if @user.valid_password?(password)
        sign_in @user
        cookies.encrypted[:id] = @user.id
        cookies.encrypted[:user] = @user.name
        redirect_to root_path
      else
        @errors = "密码错误"
        redirect_to new_user_session_path
      end
    else
      @errors = "查无此人"
      redirect_to new_user_session_path
    end

  end

  # DELETE /resource/sign_out
  def destroy
    cookies.encrypted[:id] = nil
    cookies.encrypted[:user] = nil
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
