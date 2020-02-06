class CommentsController < ApplicationController
  before_action :load_elements, only: %i[update destroy]

  def show; end

  def create
    @question = Question.find(params[:question_id]) if params[:question_id]
    @answer = Answer.find(params[:answer_id]) if params[:answer_id]
    @commentable = @answer || @question
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    gon.commentable = @commentable
    gon.commentable_id = @commentable.id
    respond_to do |format|
      if @comment.save
        format.js
        format.json { render json: { comment: @comment } }
        format.html { render partial: 'comments/comments_show', commentable: @commentable, layout: false }
        @question = @comment.commentable.question if @question.nil?
        publish_comment @comment, @question.id, 'create' unless @comment.errors.any?
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
        format.html { render plain: @comment.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    authorize @comment
    @comment.update(comment_params)
    redirect_to @question
  end

  def destroy
    authorize @comment
    @comment.destroy
    redirect_to question_path(@question.id)
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
    @question = @comment.commentable
    @question = @comment.commentable.question unless @comment.commentable.class == Question
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
