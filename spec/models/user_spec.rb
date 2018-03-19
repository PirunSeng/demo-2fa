describe User do
  context '.otp_allowed_drift' do
    it 'set to 60' do
      expect(User.otp_allowed_drift).to eq(60)
    end
  end
end
