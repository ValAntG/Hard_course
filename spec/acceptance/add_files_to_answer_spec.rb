require_relative 'acceptance_helper'

feature 'Add files to answers', "
  In order to illustrate my answers
  As an answers's author
  I'd like to be able to attach files
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks answer', js: true do
    click_on 'Ответить'
    within '.new_answer' do
      fill_in 'Your answer', with: 'My answer'

      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Create'
    end
    expect(page).to have_link('spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb')
  end
end
