class QuestionsController < ApplicationController
  before_action :load_question, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_element, only: %i[update destroy]

  respond_to :html

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit; end

  def create
    question_form = QuestionForm.new(question_params.merge(question: Question.new, user_id: current_user.id))
    authorize question_form
    publish_question(question_form) if question_form.save
    @question = question_form.question
    question_error(question_form) unless question_form.errors.empty?
    respond_with(question_form)
  end

  def update
    question_form = QuestionForm.new(question_params.merge(question: @question, user_id: current_user.id))
    question_form.update
    question_error(question_form) unless question_form.errors.empty?
    respond_with(question_form)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_error(question_form)
    flash[:alert] = "Errors: #{question_form.errors.full_messages.join("\n")}"
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def authorize_element
    authorize @question
  end

  def publish_question(question_form)
    return if question_form.errors.any?

    data_channel = ApplicationController.render(partial: 'questions/question_form',
                                                locals: { question: question_form.question })
    ActionCable.server.broadcast('questions', data_channel)
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments: [files: [], delete: {}])
  end
end
