class CreateAttempts < ActiveRecord::Migration[5.1]
  def change
    create_table :attempts do |t|
      t.boolean :active
      t.integer :user_id
      t.string :question_ids
      t.integer :attempt_count

      t.timestamps
    end

    add_index :attempts, :user_id
    add_index :attempts, :active
  end
end
