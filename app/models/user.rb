class User < ActiveRecord::Base
  devise :two_factor_authenticatable,
      otp_secret_encryption_key: ENV['TWO_FACTOR_AUTH_ENCRYPTION_KEY']

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
