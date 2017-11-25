class Question < ApplicationRecord
  def upload_audio_file file_path
    f = File.open(file_path, 'rb')
    self.recording = f.read()
    f.close()
  end
end
