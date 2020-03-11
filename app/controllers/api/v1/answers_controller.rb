module Api
  module V1
    module Question
    class AnswersController < BaseController
      def index
        binding.pry
        @answer = Question.find(params[:id]).answers
        @question = @answer.question

        @questions = Question.all
        respond_with @questions
      end

      # def show
      #   @question = Question.find(params[:id])
      #   respond_with @question
      # end
    end
    end
  end
end
