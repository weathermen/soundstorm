class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :followed, index: true
      t.references :following, index: true

      t.timestamps
    end
  end
end
