# frozen_string_literal: true

class DeleteHourOldTransactionsJob
  include Sidekiq::Job

  def perform
    transactions = Transaction.where('created_at < :hour_ago', hour_ago: 1.hour.ago)
    transactions.delete_all
  end
end
