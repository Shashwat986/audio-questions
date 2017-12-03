class AddMimetypeToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :mime_type, :string
  end
end
