class FilesController < ApplicationController
  def question
    q = Question.find(params[:id])
    send_data q.recording, type: q.mime_type
  end

  def answer
    a = Answer.find(params[:id])
    send_data a.recording, type: a.mime_type
  end
end
