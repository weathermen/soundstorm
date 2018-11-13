class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :parent, foreign_key: true
      t.references :commentable, foreign_key: true, polymorphic: true
      t.text :content, null: false

      t.timestamps
    end
  end
end
