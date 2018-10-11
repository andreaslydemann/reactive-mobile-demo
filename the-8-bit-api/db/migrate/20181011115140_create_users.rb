class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, index: true, null: false
      t.integer :high_score, index: true, null: false, default: 0
      t.timestamps
    end
  end
end
