class SessionsController < ApplicationController
  skip_before_action :logged_in_user?, only: [:new, :create]

  def new
    logged_in? ? (redirect_to current_user) : (render layout: "sublays/session_new_layout")
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:alert] = 'invalid email/password combination'  
      render 'new', layout: "sublays/session_new_layout"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
