require_relative 'acceptance_helper'

RSpec.describe 'Create question', type: :feature, js: true do
  let(:user) { create(:user) }

  describe 'Authenticated user creates question' do
    before do
      sign_in(user)
      visit questions_path
    end

    context 'with valid params' do
      before do
        click_on 'Ask question'

        fill_in 'question_title', with: 'Text question'
        fill_in 'question_body', with: 'text text'
        click_on 'Save'
      end

      it 'visible flash message' do
        expect(page).to have_content 'Your question successfully created.'
      end

      it "visible text for title question's" do
        expect(page).to have_content 'Text question'
      end

      it "visible text for body question's" do
        expect(page).to have_content 'text text'
      end
    end

    context 'with invalid params' do
      before do
        click_on 'Ask question'

        fill_in 'question_title', with: ''
        fill_in 'question_body', with: ''
        click_on 'Save'
      end

      it "visible flash message 'Title can't be blank'" do
        expect(page).to have_content 'Title can\'t be blank'
      end

      it "visible flash message 'Body can't be blank'" do
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  describe 'Non-authenticated user ' do
    before do
      visit questions_path
    end

    it 'when trying to create question visible flash message' do
      expect(page).not_to have_content 'Ask question'
    end
  end

  describe 'multiple sessions' do
    before do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'question_title', with: 'Text question'
        fill_in 'question_body', with: 'text text'
        click_on 'Save'
      end
    end

    context "when question appears on another user's page" do
      it 'visible flash message in user' do
        Capybara.using_session('user') do
          expect(page).to have_content 'Your question successfully created.'
        end
      end

      it "visible text for title question's in user" do
        Capybara.using_session('user') do
          expect(page).to have_content 'Text question'
        end
      end

      it "visible text for body question's in user" do
        Capybara.using_session('user') do
          expect(page).to have_content 'text text'
        end
      end

      it "visible text for body question's in guest" do
        Capybara.using_session('guest') do
          within '.col-lg-9' do
            expect(page).to have_content 'Text question'
          end
        end
      end
    end
  end
end
