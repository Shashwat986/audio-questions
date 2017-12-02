class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.binary :recording
      t.integer :user_id
      t.integer :attempt_id
      t.integer :question_id

      t.timestamps
    end

    add_index :answers, :user_id
    add_index :answers, :attempt_id
  end
end
