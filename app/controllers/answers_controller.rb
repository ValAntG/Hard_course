class AnswersController < ApplicationController
  before_action :load_answer, only: :update

  def show; end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
    AttachmentService.attachments_load(@answer, attachments_params) if attachments_params
  end

  def update
    authorize @answer
    @question = @answer.question
    AttachmentService.element_update(@answer, attachments_params, answer_params)
    redirect_to @question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body) if params[:answer]
  end

  def attachments_params
    params.require(:attachments).permit(:_destroy, :id, file: []) if params[:attachments]
  end
end
