class AnswersController < ApplicationController
  before_action :load_answer, only: :update

  def show; end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.permit(:body).merge(user_id: current_user.id))
    return unless answer_params.dig(:attachments)

    AttachmentService.attachments_load(@answer, answer_params.permit(attachments: { files: [] }))
  end

  def update
    authorize @answer
    @question = @answer.question
    AttachmentService.element_update(@answer, answer_params)
    redirect_to @question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments: [:_destroy, :id, files: []])
  end
end
