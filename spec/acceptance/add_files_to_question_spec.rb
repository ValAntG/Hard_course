require_relative 'acceptance_helper'

RSpec.describe 'Add files to question', type: :feature do
  let(:user) { create(:user) }

  context 'when add attachment for question', js: true do
    before do
      sign_in(user)
      visit new_question_path

      fill_in 'question_title', with: 'Test question'
      fill_in 'question_body', with: 'text text text'

      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Save'
    end

    it 'visible link for attachment on this page' do
      expect(page).to have_link('spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb')
    end
  end
end
