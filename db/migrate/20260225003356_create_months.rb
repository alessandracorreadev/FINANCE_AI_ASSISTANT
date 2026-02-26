class CreateMonths < ActiveRecord::Migration[7.1]
  def change
    create_table :months do |t|
      t.string :month
      t.integer :year
      t.text :overview
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
