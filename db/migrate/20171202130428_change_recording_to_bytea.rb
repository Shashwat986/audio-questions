class ChangeRecordingToBytea < ActiveRecord::Migration[5.1]
  def change
    change_column :questions, :recording, 'bytea USING recording::bytea'
  end
end
