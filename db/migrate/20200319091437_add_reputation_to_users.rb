class AddReputationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :reputation, :integer, default: 0
  end
end
