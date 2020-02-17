require_relative 'acceptance_helper'

RSpec.describe 'Add files to question', type: :feature, js: true do
  let(:user) { create(:user) }

  context 'when add attachment for question' do
    before do
      sign_in(user)
      visit new_question_path

      fill_in 'question_title', with: 'Test question'
      fill_in 'question_body', with: 'text text text'

      attach_file 'File', "#{Rails.root}/spec/acceptance/test.rb"

      click_on 'Save'
    end

    it 'visible link for attachment on this page' do
      expect(page).to have_link('test.rb', href: '/uploads/attachment/file/1/test.rb')
    end
  end
end
