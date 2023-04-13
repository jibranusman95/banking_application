# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteHourOldTransactionsJob, type: :job do
  let(:merchant) { FactoryBot.create(:merchant, email: 'm@b.com', password: 'password') }
  let(:customer) { FactoryBot.create(:customer, email: 'c@b.com', password: 'password') }
  let!(:transaction_before_1_hour) do
    FactoryBot.create(:authorize_transaction, amount: 20,
                                              merchant_account_id: merchant.merchant_account.id,
                                              customer_email: customer.email,
                                              created_at: (1.hour + 1.minute).ago)
  end

  let!(:transaction_within_1_hour) do
    FactoryBot.create(:authorize_transaction, amount: 20,
                                              merchant_account_id: merchant.merchant_account.id,
                                              customer_email: customer.email,
                                              created_at: 59.minutes.ago)
  end

  context 'when there are multiple transactions created before and after 1 hour' do
    before do
      Sidekiq::Testing.inline! do
        described_class.perform_async
      end
    end

    it 'deletes the transactions older than an hour' do
      expect { transaction_before_1_hour.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'keeps the jobs younger than an hour' do
      expect(transaction_within_1_hour.reload.id).to be_present
    end
  end
end
