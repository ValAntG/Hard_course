class QuestionsController < ApplicationController
  before_action :load_question, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @comment = @question.comments.build
    @answer.attachments.build
    @attachments_size_question = @question.attachments.size
  end

  def new
    @question = Question.new
    @question.attachments.build
    @attachments_size_question = 0
  end

  def edit; end

  def create
    @attachments_size_question = 0
    @question_form = QuestionForm.new(question_params)
    @question_form.user_id = current_user.id
    if @question_form.save
      redirect_to question_url(@question_form.question), notice: 'Your question successfully created.'
      publish_question
    else
      @question = Question.new(title: @question_form[:title], body: @question_form[:body])
      question_errors = []
      @question_form.errors.messages.each do |key, value|
        question_errors.push("#{key.to_s.capitalize} #{value.first}")
      end
      flash[:alert] = "Ошибка: #{question_errors}"
      render :new
    end
  end

  def update
    authorize @question
    @question_form = QuestionForm.new(question_params.merge(id: @question.id, user_id: current_user.id))
    @question_form.update
    redirect_to @question
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_question
    return if @question_form.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_form',
        locals: { question: @question_form.question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments: [:_destroy, :id, files: []])
  end
end
