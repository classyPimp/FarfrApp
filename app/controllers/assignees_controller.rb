class AssigneesController < ApplicationController


#-----------ACTION METHODS
  def update
    @assignee = Assignee.find(params[:id])
    if @assignee.update(update_params)
      redirect_to assignment_path(@assignee.assignment_id), notice: 'update succesfull'
    else
      redirect_to assignment_path(@assignee.assignment_id), notice: 'error occured'
    end
  end

#------------PRAMS METHODS

  def update_params
    params.require(:assignee).permit({attachments_attributes: [:attachment, :description]})
  end
end
