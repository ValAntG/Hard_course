class AnswersController < ApplicationController
  before_action :load_elements, only: %i[update destroy]
  # after_action :publish_answer, only: [:create]

  def show; end

  def create
    @question = Question.find(params[:question_id])
    @answer_form = AnswerForm.new(answer_params.merge(user_id: current_user.id, question_id: @question.id))
    respond_to do |format|
      if @answer_form.save
        @comment = @answer_form[:answer].comments.build(user_id: current_user.id)
        format.js
        format.html { render partial: 'answers/answers_show', layout: false }
        format.json { render json: { answer: @answer_form, attachments: @answer_form.answer.attachments } }
        publish_answer @answer_form.answer, params[:question_id], 'create' unless @answer_form.errors.any?
      else
        format.html { render plain: @answer_form.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.json { render json: @answer_form.errors.full_messages, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    authorize @answer
    @answer_form = AnswerForm.new(answer_params.merge(id: @answer.id, user_id: current_user.id,
                                                      question_id: @question.id))
    @answer_form.update
    redirect_to @question
  end

  def destroy
    authorize @answer
    @answer.destroy
    redirect_to question_path(@question.id)
  end

  private

  def load_elements
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def publish_answer(answer, question, action)
    ActionCable.server.broadcast(
      "questions/#{question}/answers",
      { answer: AnswerSerializer.new(answer), action: action }.as_json
    )
  end

  def answer_params
    params.require(:answer).permit(:body, attachments: [:_destroy, :id, files: []])
  end
end
