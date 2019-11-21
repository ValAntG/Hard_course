class AnswersController < ApplicationController
  before_action :load_answer, only: :update

  def show
    @answer.order(created_at: :desc)
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    authorize @answer
    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
