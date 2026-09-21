module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_token!

      private

      attr_reader :current_api_user

      def authenticate_token!
        token = request.headers["Authorization"].to_s.sub(/\ABearer /, "").presence || params[:token].to_s.presence
        @current_api_user = User.find_by(api_token: token)
        render json: { error: "Não autorizado" }, status: :unauthorized if @current_api_user.nil?
      end
    end
  end
end
