class CreateCoffeeRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :coffee_records do |t|
      t.references :user, null: false, foreign_key: true
      t.string :bean_name, null: false
      t.integer :grind_size, null: false
      t.integer :bean_amount, null: false
      t.integer :water_temperature, null: false
      t.integer :brew_time, null: false
      t.integer :water_amount, null: false
      t.text :brew_memo
      t.integer :acidity
      t.integer :bitterness
      t.integer :sweetness
      t.integer :body
      t.integer :off_flavor
      t.text :comment

      t.timestamps
    end
  end
end
