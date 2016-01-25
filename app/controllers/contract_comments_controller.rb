class ContractCommentsController < ApplicationController

#================ACTION METHODS
  def create
    @comment = ContractComment.new(new_params)
    respond_to do |f|
      if @comment.save
        f.json { render json: {status: 200}, :status => 200 }  
      else
        f.json { render json: @comment.errors, status: 500 }
      end
    end
  end

  def update
    if satisfy_comment_if_querried
      render nothing: true, status: 200
    end
  end

  def index
    @comments = ContractComment.includes(:user).where(contract_id: params[:contract_id])
    
  end

#=================PARAMS METHODS
  def new_params
    #TODO: Move to _comment_form as hidden fields with default values
    params.require(:contract_comment).permit(:parent_id, :user_id, :contract_id,  
                                             :body, :read, :parent_node, :satisfied)
  end

  def satisfy_comment_if_querried
    if params[:satisfy]
      #todo: move to model
      @comment = ContractComment.find(params[:id].to_i)
      (@comment.satisfied = Time.now
      @comment.save) if @comment.user_id == current_user.id
      true
    end
  end
end
