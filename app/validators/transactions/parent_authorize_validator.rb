# frozen_string_literal: true

module Transactions
  class ParentAuthorizeValidator < ActiveModel::Validator
    def validate(record)
      return unless record.parent.present? && !record.parent.authorize_transaction?

      record.errors.add(:parent, 'can only be authorize transaction')
    end
  end
end
