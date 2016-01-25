class CommentsController < ApplicationController

#-----------ACTION METHODS

  def create
    
    @comment = Comment.new(new_params)
    respond_to do |f|
      if @comment.save
        f.json { render json: {status: 200}, :status => 200 }  
      else
        f.json { render json: @comment.errors, status: 500 }
      end
    end
  end

  def update
    render plain: params and return
    if satisfy_comment_if_querried
      render nothing: true, status: 200
    end
  end

  def index
    
    @comments = Comment.includes(:user).where(commentable_id: params[:commentable_id], commentable_type: params[:commentable_type])
    
  end

#----------STRONG PARAMS
  def new_params
    #TODO: Move to _comment_form as hidden fields with default values
    params.require(:comment).permit(:parent_id, :user_id, :commentable_id, :commentable_type,  
                                             :body, :parent_node)
  end
end
