class AnswersController < ApplicationController
  before_action :load_answer, only: :update

  def show; end

  def create
    @question = Question.find(params[:question_id])
    @answer_form = AnswerForm.new(answer_params.merge(user_id: current_user.id, question_id: @question.id))
    respond_to do |format|
      if @answer_form.save
        format.html { render partial: 'questions/answers_show', layout: false }
        format.json { render json: { answer: @answer, attachments: @answer.attachments } }
      else
        format.html { render plain: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @answer
    @question = Question.find(params[:question_id])
    @answer_form = AnswerForm.new(answer_params.merge(id: @answer.id, user_id: current_user.id,
                                                      question_id: @question.id))
    @answer_form.update
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
