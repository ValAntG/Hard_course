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
      within '.edit_question' do
        fill_in 'question_title', with: 'Edited title'
        fill_in 'question_body', with: 'Edited body'
        click_on 'Save'
      end
      within '.question-show-form' do
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector('textarea', visible: true)
        expect(page).to have_content 'Edited title'
      end
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
