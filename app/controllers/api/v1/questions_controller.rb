module Api
  module V1
    class QuestionsController < BaseController
      def index
        questions = Question.all
        respond_with questions.to_json
      end

      def show
        if question = Question.find_by(id: params[:id])
          respond_with question
        else
          render json: {status: "error", code: 404, message: "Can't find question"}
        end
      end

      def create
        question = Question.create(question_params.merge(user_id: current_resource_owner.id))
        respond_with question
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
