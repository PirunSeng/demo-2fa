class SessionsController < Devise::SessionsController
  def create
    resource = User.find_by_email(params[:user][:email])
    if resource && resource.otp_required_for_login?
      if params[:user][:otp_attempt].size > 0
        totp = ROTP::TOTP.new(resource.otp_secret)
        if totp.verify_with_drift(params[:user][:otp_attempt], 600)
          super
        else
          sign_out
          redirect_to url_for, alert: t('.bad_credentials_supplied')
        end
      else
        sign_out
        redirect_to url_for, alert: t('.your_account_needs_to_supply_a_verification_code')
      end
    else
      super
    end
  end
end
