class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commentable, polymorphic: true

      t.bigint "user_id"
      t.index ["user_id"], name: "index_comments_on_user_id"
      t.timestamps
    end
  end
end
