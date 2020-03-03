class CommentsController < ApplicationController
  before_action :load_elements, except: :create

  respond_to :json, :js

  authorize_resource

  def create
    @comment = Comment.new(comment_params.merge(user: current_user))
    publish_comment @comment, question_id_params, 'create' if @comment.save
    respond_with(@comment)
  end

  def update
    @comment.update(comment_params)
    respond_with(@comment, location: question_path(question_id_params))
  end

  def destroy
    @comment.destroy
    respond_with(@comment, location: question_path(question_id_params))
  end

  private

  def load_elements
    @comment = Comment.find(params[:id])
  end

  def publish_comment(comment, question_id, action)
    data_channel = {
      comment: CommentSerializer.new(comment),
      action: action,
      commentable_type: comment.commentable_type,
      commentable_id: comment.commentable_id
    }.as_json
    ActionCable.server.broadcast("questions/#{question_id}/comments", data_channel)
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end

  def question_id_params
    params[:comment][:question_id].to_i
  end
end
