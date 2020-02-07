require_relative 'acceptance_helper'

RSpec.describe 'Create answer', type: :feature do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  context 'when authenticated user create valid answer', js: true do
    before do
      sign_in(user)
      visit question_path(question)

      click_on 'Ответить'
      within '.new_answer' do
        fill_in 'Your answer', with: 'My answer'
        click_on 'Create answer'
      end
    end

    it 'redirected to the question page' do
      expect(page).to have_current_path question_path(question)
    end

    it 'visible text for text answer' do
      within '.answers' do
        expect(page).to have_content 'My answer'
      end
    end
  end

  context 'when authenticated user create invalid answer', js: true do
    before do
      sign_in(user)
      visit question_path(question)
      click_on 'Ответить'
      within '.new_answer' do
        click_on 'Create answer'
      end
    end

    it 'visible flash message' do
      expect(page).to have_content "Body can't be blank"
    end
  end
end
