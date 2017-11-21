class HomeController < ApplicationController
  def index
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
  end
end
