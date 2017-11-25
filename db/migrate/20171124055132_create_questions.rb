class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.text :text
      t.string :mime_type
      t.text :recording

      t.timestamps
    end
  end
end
