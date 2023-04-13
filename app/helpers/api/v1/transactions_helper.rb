# frozen_string_literal: true

module Api
  module V1
    module TransactionsHelper
      %w[render_success render_failure].each do |method_name|
        define_method(method_name) do |**attrs|
          message = method_name.split('_').last
          render json: { message: message, **attrs }
        end
      end
    end
  end
end
