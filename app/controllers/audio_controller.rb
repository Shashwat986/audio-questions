class AudioController < ApplicationController
  def index
    @id = 0
    render "show"
  end

  def show
    @id = params[:id].to_i || 1
  end

  def question_audio
    send_data File.binread('public/uploads/test.webm'), type: 'audio/webm'
  end

  def create
    file = params[:file]
    filetype =
      case file.content_type
      when 'audio/webm'
        '.webm'
      when 'audio/ogg'
        '.ogg'
      else
        '.' + file.content_type.split('/')[-1]
      end
    File.open(Rails.root.join('public', 'uploads', file.original_filename + filetype), 'wb') do |f|
      f.write(file.read)
    end

    render json: {
      status: true
    }
  end
end
