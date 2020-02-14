class CommentsController < ApplicationController
  before_action :load_elements, only: %i[update destroy]

  def show; end

  def create
    @comment = Comment.new(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.js
        format.json { render json: { comment: @comment } }
        format.html { render partial: 'comments/comments_show', locals: { comment: @comment }, layout: false }
        publish_comment @comment, question_id_params, 'create' unless @comment.errors.any?
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
        format.html { render plain: @comment.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    authorize @comment
    if @comment.update(comment_params)
      redirect_to question_path(question_id_params)
    else
      render :edit
    end
  end

  def destroy
    authorize @comment
    if @comment.destroy
      redirect_to question_path(question_id_params)
    else
      render :edit
    end
  end

  private

  def publish_comment(comment, question_id, action)
    ActionCable.server.broadcast(
      "questions/#{question_id}/comments", {
        comment: CommentSerializer.new(comment), action: action, commentable_type: comment.commentable_type,
        commentable_id: comment.commentable_id
      }.as_json
    )
  end

  def load_elements
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id)
  end

  def question_id_params
    params[:comment][:question_id].to_i
  end
end
