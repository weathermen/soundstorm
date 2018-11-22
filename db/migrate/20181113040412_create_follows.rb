class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :follower, index: true
      t.references :followed, index: true

      t.timestamps
    end
  end
end
