# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ActionController::API
      include JsonWebToken

      def login
        @merchant = Merchant.find_by_email(params[:email])
        if @merchant&.valid_password?(params[:password])
          token = encode(user_id: @merchant.id)
          time = Time.now + 24.hours.to_i
          render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M'),
                         email: @merchant.email }, status: :ok
        else
          render json: { error: :unauthorized }, status: :unauthorized
        end
      end
    end
  end
end
