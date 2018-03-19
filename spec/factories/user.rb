FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{n}-#{FFaker::Internet.email}" }
    password { (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).sample(8).join }
    otp_secret { User.generate_otp_secret }
  end
end
