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
    else
      @question = Question.new(title: @question_form[:title], body: @question_form[:body])
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
    @question.comments.destroy_all
    @question.answers.each do |answer|
      answer.comments.destroy_all
      answer.attachments.destroy_all
    end
    @question.answers.destroy_all
    @question.destroy
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments: [:_destroy, :id, files: []])
  end
end
