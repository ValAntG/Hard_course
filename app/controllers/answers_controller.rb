class AnswersController < ApplicationController
  before_action :load_elements, :authorize_element, only: %i[update destroy]

  respond_to :json, :js

  def create
    answer_attr = answer_params.merge(answer: Answer.new, user_id: current_user.id, question_id: params[:question_id])
    @answer_form = AnswerForm.new(answer_attr)
    authorize @answer_form
    publish_answer(@answer_form.answer, params[:question_id], 'create') if @answer_form.save
    respond_with(@answer_form, location: question_path(@answer_form.question_id))
  end

  def update
    answer_attr = answer_params.merge(answer: @answer, user_id: current_user.id, question_id: @question.id)
    answer_form = AnswerForm.new(answer_attr)
    answer_form.update
    respond_with(answer_form, location: question_path(@question.id))
  end

  def destroy
    @answer.destroy
    respond_with(@answer, location: question_path(@question.id))
  end

  private

  def load_elements
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def authorize_element
    authorize @answer
  end

  def publish_answer(answer, question, action)
    data_channel = { answer: AnswerSerializer.new(answer), action: action }.as_json
    ActionCable.server.broadcast("questions/#{question}/answers", data_channel)
  end

  def answer_params
    params.require(:answer).permit(:body, attachments: [files: [], delete: {}])
  end
end
