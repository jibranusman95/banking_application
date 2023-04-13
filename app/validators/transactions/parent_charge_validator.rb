# frozen_string_literal: true

module Transactions
  class ParentChargeValidator < ActiveModel::Validator
    def validate(record)
      return unless record.parent.present? && !record.parent.charge_transaction?

      record.errors.add(:parent, 'can only be charge transaction')
    end
  end
end
