require_relative 'acceptance_helper'

RSpec.describe 'Question edition', type: :feature do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'Unauthenticated user' do
    it 'try to edit question' do
      visit question_path(question)
      expect(page).not_to have_link 'Edit question'
    end
  end

  describe 'Authentificated user' do
    context 'when he see his created question' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      it 'sees a link edit' do
        expect(page).to have_link 'Edit question'
      end
    end

    context 'when he edit his created question' do
      before do
        sign_in(user)
        visit question_path(question)

        click_on 'Edit question'
        within '.edit_question' do
          fill_in 'question_title', with: 'Edited title'
          fill_in 'question_body', with: 'Edited body'
          click_on 'Save'
        end
      end

      it "appeared new body question's", js: true do
        within '.question-show-form' do
          expect(page).to have_content 'Edited title'
        end
      end

      it "disappeared old body question's", js: true do
        within '.question-show-form' do
          expect(page).not_to have_content question.body
        end
      end

      it 'disappeared field for edit question', js: true do
        within '.question-show-form' do
          expect(page).not_to have_selector('textarea', visible: true)
        end
      end
    end

    context "when he see other's question" do
      before do
        sign_in(user2)
        visit question_path(question)
      end

      it "don't see a link edit" do
        expect(page).not_to have_link 'Edit question'
      end
    end
  end
end
