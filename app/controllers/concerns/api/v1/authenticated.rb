# frozen_string_literal: true

module Api
  module V1
    module Authenticated
      include JsonWebToken
      extend ActiveSupport::Concern

      included do
        before_action :authorize_request
      end

      def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = decode(header)
          @current_user = Merchant.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        end
      end
    end
  end
end
