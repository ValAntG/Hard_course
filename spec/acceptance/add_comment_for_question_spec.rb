require_relative 'acceptance_helper'

RSpec.describe 'Add comment for question', type: :feature do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  context 'when authenticated user try to create valid comment', js: true do
    before do
      within '.commentsForQuestion' do
        click_on 'Комментировать'
        within '.new_comment' do
          fill_in 'comment[body]', with: 'My comment'
          click_on 'Create comment'
        end
      end
    end

    it 'redirected to the question page' do
      expect(page).to have_current_path question_path(question)
    end

    it 'visible text for text comment' do
      within '.commentsForQuestion' do
        expect(page).to have_content 'My comment'
      end
    end
  end

  context 'when authenticated user create invalid comment', js: true do
    before do
      within '.commentsForQuestion' do
        click_on 'Комментировать'
        within '.new_comment' do
          fill_in 'comment[body]', with: ''
          click_on 'Create comment'
        end
      end
    end

    it 'visible flash message' do
      expect(page).to have_content "Body can't be blank"
    end
  end
end
