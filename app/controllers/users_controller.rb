class UsersController < ApplicationController
  


  skip_before_action :logged_in_user?, only: [:new, :create]
  before_filter :cabinet_owner, only: [:show]



#============================================ACTION METHODS
  def new
    @user = User.new
    render layout: "sublays/session_new_layout"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user
      flash[:succes] = "Welcome, you've successfully created_account"
    else
      render "new", layout: "sublays/session_new_layout"
    end
  end

  def update
  end

  def edit
  end
 
  def destroy
  end

  def show
    @user = User.find(params[:id])
    @notifications = UserNotification.where(user_id: current_user, read: nil)
    @confirmations = @user.pending_confirmations.includes(confirmation: [:initiator_user])
    render
    Assignee.set_user_notified(current_user)
  end

  def index
    @users = User.all
  end
#=============================</ACTION METHODS--


#------------------------------------------------- params methods
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)    
  end


#----------------------------- </--params methods
  
#--------------------------------------------------filters methods
  def cabinet_owner
    unless params[:id] == current_user.id.to_s
      redirect_to root_url, alert: "unauthorized"
    end
  end
#------------------------------</--filters methods
end
