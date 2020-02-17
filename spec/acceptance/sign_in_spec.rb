require_relative 'acceptance_helper'

RSpec.describe 'SignIns', type: :feature, js: true do
  describe 'User sign in' do
    context 'when registered user try to login' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'show message' do
        expect(page).to have_content 'Signed in successfully'
      end

      it 'redirected to the root page' do
        expect(page).to have_current_path root_path
      end
    end

    context 'when non-registered user try to login' do
      before do
        visit new_user_session_path
        fill_in 'Email', with: 'wrong@test.com'
        fill_in 'Password', with: '12345678'
        click_on 'Log in'
      end

      it 'show message' do
        expect(page).to have_content 'Invalid Email or password.'
      end

      it 'stays on the old page' do
        expect(page).to have_current_path new_user_session_path
      end
    end
  end
end
