class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def require_login
    unless user_signed_in?
      redirect_to user_session_path
      return
    end
  end
end
