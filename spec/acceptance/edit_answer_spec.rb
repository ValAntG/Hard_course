require_relative 'acceptance_helper'

feature 'Answer edition', '
  In order fo mix mistake
  As an author of answer
  I did like ot be able to edit my answer
' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question2, user: user) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authentificated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      within '.answers' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'sees a link to edit the answer, question created by another user' do
      visit question_path(question2)
      within '.answers' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector('textarea', visible: true)
      end
    end
  end

  describe 'Authentificated other user' do
    scenario "try to edit first user's question" do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end
  end
end
