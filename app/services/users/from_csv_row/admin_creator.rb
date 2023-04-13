# frozen_string_literal: true

module Users
  module FromCsvRow
    class AdminCreator < Base
      def call
        Admin.create!(email: @row[:email], password: @row[:password])

        true
      rescue StandardError => e
        "#{@index}. #{e.message}"
      end
    end
  end
end
