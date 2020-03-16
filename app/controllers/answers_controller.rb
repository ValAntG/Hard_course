class AnswersController < ApplicationController
  before_action :load_elements, only: %i[update destroy]

  respond_to :json, :js

  authorize_resource

  def create
    @answer_form = init_answer_form(Answer.new, params[:question_id])
    publish_answer(@answer_form.answer, params[:question_id], 'create') if @answer_form.save
    respond_with(@answer_form, location: question_path(@answer_form.question_id))
  end

  def update
    answer_form = init_answer_form(@answer, @question.id)
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

  def publish_answer(answer, question, action)
    data_channel = { answer: AnswerSerializer.new(answer), action: action }.as_json
    ActionCable.server.broadcast("questions/#{question}/answers", data_channel)
  end

  def answer_params
    params.require(:answer).permit(:body, attachments: [files: [], delete: {}])
  end

  def init_answer_form(answer, question_id)
    answer_attr = answer_params.merge(answer: answer, user_id: current_user.id, question_id: question_id)
    AnswerForm.new(answer_attr)
  end
end
