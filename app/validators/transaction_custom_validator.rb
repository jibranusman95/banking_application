# frozen_string_literal: true

class TransactionCustomValidator < ActiveModel::Validator
  def validate(record)
    if record.merchant_account.present? && record.merchant_account.inactive?
      record.errors.add(:merchant, 'cannot be inactive')
    end

    return unless record.parent.present? && %w[approved refunded].exclude?(record.parent.status)

    record.status = 'error'
  end
end
