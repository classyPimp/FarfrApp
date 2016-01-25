class UserNotificationsController < ApplicationController
  
  def update
    if UserNotification.where(id: (params[:user_notifications][:notification_ids] - ["0"]), 
                              user_id: current_user.id).update_all(read: Time.now)
      respond_to do |f|
        f.json {render json:{status: "OK"}, status: :ok}
      end
    else
      render nothing: true, status: :error
    end
  end

end
