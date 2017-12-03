class AudioController < ApplicationController
  before_action :require_login, :get_attempt, except: [:result]

  def index
    redirect_to action: "show", id: @id
  end

  def show
    question = @attempt.active_question(@id)
    @question_id = question.id
    @answer = Answer.find_by_auq(@attempt.id, current_user.id, question.id)

    @all_attempted = (@attempt.attempt_count == Attempt::MAX)
  end

  def answer
    file = params[:file]
    answer = Answer.where(
      attempt_id: @attempt.id,
      user_id: current_user.id,
      question_id: @attempt.active_question(@id).id,
    ).first_or_create do
      # Only executes if answer was created
      @attempt.attempt_count += 1
      @attempt.save
    end

    answer.update(
      recording: file.read,
      mime_type: file.content_type
    )


    flash[:notice] = "Submission successful"

    render json: {
      status: true
    }
  end

  def end
    @attempt.set_inactive
    redirect_to action: 'result', id: @attempt.get_hash
  end

  def result
    @attempt = Attempt.find_by_hash params[:id]
    head 404 if @attempt.nil?
  end

  private

  def get_attempt
    @attempt = current_user.active_attempt

    if @attempt.nil?
      @attempt = current_user.attempts.create({
        active: true
      })
    end

    if params[:id] && params[:id].to_i > @attempt.question_count
      # TODO: Change MAX to last attempted
      redirect_to action: "show", id: Attempt::MAX
      return
    end
    # TODO: Change 1 to last attempted
    @id = (params[:id] || 1).to_i
  end
end
