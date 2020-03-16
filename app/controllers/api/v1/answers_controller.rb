module Api
  module V1
    class AnswersController < BaseController
      def index
        if (question = Question.find_by(id: params[:question_id]))
          respond_with question.answers.to_json
        else
          render json: { status: 'error', code: 404, message: "Can't find question" }
        end
      end

      def show
        if (answer = Answer.find_by(id: params[:id]))
          respond_with answer
        else
          render json: { status: 'error', code: 404, message: "Can't find answer" }
        end
      end

      def create
        answer = Answer.create(answer_params.merge(user_id: current_resource_owner.id,
                                                   question_id: params[:question_id]))
        respond_with answer
      end

      private

      def answer_params
        params.require(:answer).permit(:body, attachments: [files: [], delete: {}])
      end
    end
  end
end
