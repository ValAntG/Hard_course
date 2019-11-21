class AddUserToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :questions, :user
  end
end
