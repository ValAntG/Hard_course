class CommentsController < ApplicationController
  before_action :load_comment, only: %i[update destroy]

  def show; end

  def create
    @question = Question.find(params[:question_id]) if params[:question_id]
    @answer = Answer.find(params[:answer_id]) if params[:answer_id]
    @commentable = @answer || @question
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.js
        format.json { render json: { comment: @comment } }
        format.html { render partial: 'questions/comments_show', commentable: @commentable, layout: false }
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
        format.html { render plain: @comment.errors.full_messages.join("\n"), status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @comment
    #while @question.class != Question
    #  @question = @comment.commentable
    #  @question = @comment.commentable.question
    #end
    @question = @comment.commentable
    @question = @comment.commentable.question unless @comment.commentable.class == Question
    @comment.update(comment_params)
    redirect_to @question
  end

  def destroy
    authorize @comment
    @comment.destroy
    redirect_to question_path(params[:question_id])
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
