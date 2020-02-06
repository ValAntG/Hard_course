require_relative 'acceptance_helper'

feature 'Add comment for answer',
        'To comment answers
  As an authenticated user
  I want to be able to create comment', type: :feature do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }
  let!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  scenario 'Authenticated user create comment', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers-index-form' do
      click_on 'Комментировать'
      within '.new_comment' do
        fill_in 'comment[body]', with: 'My comment'
        click_on 'Create comment'

        expect(current_path).to eq question_path(question)
      end
      expect(page).to have_content 'My comment'
    end
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers-index-form' do
      click_on 'Комментировать'
      within '.new_comment' do
        fill_in 'comment[body]', with: ''
        click_on 'Create comment'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end
end
