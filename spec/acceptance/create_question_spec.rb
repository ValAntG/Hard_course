require_relative 'acceptance_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
' do
  given(:user) { create(:user) }

  context 'as user' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'Authenticated user creates question with valid params', js: true do
      click_on 'Ask question'

      fill_in 'question_title', with: 'Text question'
      fill_in 'question_body', with: 'text text'
      click_on 'Save'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Text question'
      expect(page).to have_content 'text text'
    end

    scenario 'Authenticated user creates question with invalid params', js: true do
      click_on 'Ask question'

      fill_in 'question_title', with: ''
      fill_in 'question_body', with: ''
      click_on 'Save'

      expect(page).to have_content 'Title can\'t be blank'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
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

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Text question'
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        within '.col-lg-9' do
          expect(page).to have_content 'Text question'
        end
      end
    end
  end

  scenario 'Non-authenticated user ties to create question', js: true do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
