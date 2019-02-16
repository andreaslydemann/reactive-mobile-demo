class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, index: { unique: true }, null: false
      t.string :password_digest, null: false
      t.string :salt, null: false
      t.timestamps
    end
    
    create_table :thoughts do |t|
      t.string :text, null: false, default: ''
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
