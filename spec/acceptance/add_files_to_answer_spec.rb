require_relative 'acceptance_helper'

RSpec.describe 'Add files to answer', type: :feature do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }

  context 'when add attachment for answer', js: true do
    before do
      sign_in(user)
      visit question_path(question)

      click_on 'Ответить'
      within '.new_answer' do
        fill_in 'Your answer', with: 'My answer'

        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

        click_on 'Create'
      end
    end

    it 'visible link for attachment on this page' do
      expect(page).to have_link('spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb')
    end
  end
end
