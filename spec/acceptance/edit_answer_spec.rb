require_relative 'acceptance_helper'

RSpec.describe 'Answer edition', type: :feature do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'Unauthenticated user' do
    it 'try to edit answer' do
      visit question_path(question)
      expect(page).not_to have_link 'Edit answer'
    end
  end

  describe 'Authentificated user' do
    context 'when he see his created answer' do
      before do
        sign_in(user)
        visit question_path(question)
      end

      it 'sees a link edit' do
        within '.answers' do
          expect(page).to have_link 'Edit answer'
        end
      end
    end

    context 'when he edit his created answer' do
      before do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit answer'
        within '.answers-index-form' do
          fill_in 'answer[body]', with: 'edited answer'
          click_on 'Save'
        end
      end

      it "appeared new body answer's", js: true do
        within '.answers-index-form' do
          expect(page).to have_content 'edited answer'
        end
      end

      it "disappeared old body answer's", js: true do
        within '.answers-index-form' do
          expect(page).not_to have_content answer.body
        end
      end

      it 'disappeared field for edit answer', js: true do
        within '.answers-index-form' do
          expect(page).not_to have_selector('textarea', visible: true)
        end
      end
    end

    context "when he see other's answer" do
      before do
        sign_in(user2)
        visit question_path(question)
      end

      it "don't see a link edit" do
        within '.answers' do
          expect(page).not_to have_link 'Edit answer'
        end
      end
    end
  end
end
