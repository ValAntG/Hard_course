require_relative 'acceptance_helper'

feature 'Question edition', '
  In order fo mix mistake
  As an author of question
  I did like ot be able to edit my question
' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authentificated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      expect(page).to have_link 'Edit question'
    end

    scenario 'try to edit his question', js: true do
      click_on 'Edit question'

      within '.questions' do
        fill_in 'question_title', with: 'edited title'
        fill_in 'question_body', with: 'edited body'
        click_on 'Save'
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector('textarea', visible: true)
      end
      expect(page).to have_content 'edited title'
    end
  end

  describe 'Authentificated other user' do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    scenario "try to edit first user's question" do
      expect(page).to_not have_link 'Edit question'
    end
  end
end