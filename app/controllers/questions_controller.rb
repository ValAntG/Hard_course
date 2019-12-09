class QuestionsController < ApplicationController
  before_action :load_question, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
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
    @question = Question.new(question_params)
    @question.user = current_user
    authorize @question
    if @question.save
      AttachmentService.attachments_load(@question, attachments_params) if attachments_params
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @question
    @attachments_size_question = @question.attachments.size
    AttachmentService.element_update(@question, attachments_params, question_params)
    redirect_to @question
  end

  def destroy
    @question.destroy
    redirect_to question_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body) if params[:question]
  end

  def attachments_params
    params.require(:attachments).permit(:_destroy, :id, file: []) if params[:attachments]
  end
end
