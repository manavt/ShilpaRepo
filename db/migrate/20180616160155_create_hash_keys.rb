class CreateHashKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :hash_keys do |t|
      t.string :token
      t.string :expires_in
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
