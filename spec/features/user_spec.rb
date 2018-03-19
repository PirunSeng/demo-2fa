describe 'User' do
  let!(:user) { create(:user) }
  before { login_as(user) }

  describe '#show' do
    describe 'when 2fa is not enabled' do
      before { visit edit_user_registration_path }

      it 'displays qr code' do
        expect(page).to have_selector('svg', count: 1)
      end
    end

    describe 'when 2fa is enabled' do
      before {
        user.otp_required_for_login = true
        user.save
        visit edit_user_registration_path
      }

      it 'hides qr code' do
        expect(page).not_to have_selector('svg')
      end
    end
  end

  describe '#enable' do
    before { visit edit_user_registration_path }
    it 'valid' do
      click_on 'Enable 2FA'
      fill_in 'multi_factor_authentication_otp_attempt', with: user.current_otp
      click_on 'Enable'
      expect(page).to have_content('Two Factor Authentication enabled')
      expect(user.reload.otp_required_for_login).to be_truthy
    end

    it 'invalid' do
      click_on 'Enable 2FA'
      fill_in 'multi_factor_authentication_otp_attempt', with: '123456'
      click_on 'Enable'
      expect(page).to have_content('Two Factor Authentication could not be enabled')
      expect(user.reload.otp_required_for_login).to be_falsey
    end
  end

  describe '#disable' do
    before {
      user.otp_required_for_login = true
      user.save
      visit edit_user_registration_path
    }
    it 'valid' do
      click_on 'Disable 2FA'
      fill_in 'multi_factor_authentication_otp_attempt', with: user.current_otp
      click_on 'Disable'
      expect(page).to have_content('Two Factor Authentication disabled')
      expect(user.reload.otp_required_for_login).to be_falsey
    end

    it 'invalid' do
      click_on 'Disable 2FA'
      fill_in 'multi_factor_authentication_otp_attempt', with: '123456'
      click_on 'Disable'
      expect(page).to have_content('Two Factor Authentication could not be disabled')
      expect(user.reload.otp_required_for_login).to be_truthy
    end
  end
end
