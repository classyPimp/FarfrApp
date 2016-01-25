class AssignmentsController < ApplicationController

#--------------ACTION METHODS
  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = Assignment.new(new_params)
    if @assignment.save
      redirect_to @assignment, notice: 'assignment created'
    else
      render :new, notice: 'error occured'
    end
  end

  def show
    @assignment = Assignment.find(params[:id])
    set_assignee_visited
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update(update_params)
      redirect_to @assignment, notice: 'succesfully updated'
    else
      raise 'hello there'
      render @assignment, notice: 'error occured'
    end
  end

  def index
    if params[:filed] == true
      @assignments = Assignment.where(user_id: current_user.id).paginate(page: params[:page], per_page: 20)
    end
    if params[:q] != nil
      @assignments = Assignment.ransack(index_search_params)
      @assignments = @assignments.result
    end
  end
#------------STRONG PARAMS

  def new_params
    params[:assignment][:user_id] = current_user.id
    params.require(:assignment).permit(:short_description, :assignment_details, :deadline, :report_form, :user_id,
                                        {assignees_attributes: [:user_id, :_destroy]}, 
                                        {attachments_attributes: [:attachment, :_destroy, :description]})
  end  

  def update_params
    if params[:assignment][:completion_confirmed] != nil && params[:assignment][:user_id].to_s != current_user.id.to_s
      raise "acccess error: no rights"
    end
    params[:assignment][:completion_confirmed] = Time.now if params[:completion_confirmed]
    params.require(:assignment).permit(:short_description, :assignment_details, :deadline, :report_form, :user_id, :completion_confirmed,
                                        {assignees_attributes: [:user_id, :_destroy]}, 
                                        {attachments_attributes: [:attachment, :_destroy, :description]})
    
  end 

  def index_search_params
    if params[:q][:completion_confirmed_not_null] == '1' && params[:q][:completion_confirmed_null] == '1'
      params[:q].delete :completion_confirmed_not_null
      params[:q].delete :completion_confirmed_null
    end
    params[:q][:user_id_eq] = current_user.id
    params.require(:q).permit(:completion_confirmed_not_null, :completion_confirmed_null, :assignees_user_id_in, :completion_confirmed_gt)  
  end
#------------------OTHER METHODS
  def set_assignee_visited
    assignee = @assignment.assignees().where(user_id: current_user.id, visited: nil).first
    assignee.update(visited: Time.now) unless assignee.blank?
  end


end
 