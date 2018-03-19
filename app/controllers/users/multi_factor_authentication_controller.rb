class Users::MultiFactorAuthenticationController < ApplicationController

  def verify_enable
    if current_user.validate_and_consume_otp!(params[:multi_factor_authentication][:otp_attempt])
       current_user.otp_required_for_login = true
       current_user.save!

       redirect_to edit_user_registration_path, notice: 'Two Factor Authentication enabled'
    else
      redirect_to edit_user_registration_path, alert: 'Two Factor Authentication could not be enabled'
    end
  end

  def verify_disabled
    if current_user.validate_and_consume_otp!(params[:multi_factor_authentication][:otp_attempt])
      current_user.otp_required_for_login = false
      current_user.save!
      redirect_to edit_user_registration_path, notice: 'Two Factor Authentication disabled'
    else
      redirect_to edit_user_registration_path, alert: 'Two Factor Authentication could not be disabled'
    end
  end
end
