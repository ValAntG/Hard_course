class AddUserToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :answers, :user
  end
end
