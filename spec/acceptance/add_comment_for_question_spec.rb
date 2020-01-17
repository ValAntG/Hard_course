require_relative 'acceptance_helper'

feature 'Add comment for question', '
  To comment questions
  As an authenticated user
  I want to be able to create comment
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  scenario 'Authenticated user create comment', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your comment', with: 'My comment'

    click_on 'Create comment'
    expect(current_path).to eq question_path(question)
    within '.comments' do
      expect(page).to have_content 'My comment'
    end
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Create comment'

    expect(page).to have_content "Body can't be blank"
  end
end
