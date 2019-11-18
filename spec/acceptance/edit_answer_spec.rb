require_relative 'acceptance_helper'

feature 'Answer edition', '
  In order fo mix mistake
  As an author of answer
  I did like ot be able to edit my answer
' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authentificated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector('textarea', visible: true)
      end
    end

    scenario "try to edit other user's question" do
      expect(page).to have_link 'Edit'
    end
  end
end
