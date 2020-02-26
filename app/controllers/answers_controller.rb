class AnswersController < ApplicationController
  before_action :load_elements, :authorize_element, only: %i[update destroy]

  respond_to :json, :js

  def create
    @answer_form = AnswerForm.new(answer_params.merge(user_id: current_user.id, question_id: params[:question_id]))
    authorize @answer_form
    publish_answer @answer_form.answer, params[:question_id], 'create' if @answer_form.save
    respond_with(@answer_form)
  end

  def update
    @answer_form = AnswerForm.new(answer_params.merge(id: @answer.id, question_id: @question.id,
                                                      user_id: current_user.id))
    @answer_form.update
    respond_with(@comment, location: question_path(@question.id))
  end

  def destroy
    @answer.destroy
    respond_with(@comment, location: question_path(@question.id))
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
    params.require(:answer).permit(:body, attachments: [:_destroy, :id, files: [], delete: {}])
  end
end
