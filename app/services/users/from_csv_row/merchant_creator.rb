# frozen_string_literal: true

module Users
  module FromCsvRow
    class MerchantCreator < Base
      def call
        Merchant.create!(email: @row[:email], password: @row[:password],
                         merchant_account_attributes: {
                           name: @row[:merchant_name],
                           description: @row[:merchant_description],
                           status: @row[:merchant_status]
                         })

        true
      rescue StandardError => e
        "#{@index}. #{e.message}"
      end
    end
  end
end
