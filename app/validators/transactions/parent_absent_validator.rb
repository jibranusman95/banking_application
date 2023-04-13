# frozen_string_literal: true

module Transactions
  class ParentAbsentValidator < ActiveModel::Validator
    def validate(record)
      return unless record.parent.present?

      record.errors.add(:parent, 'can not be present for authorize transaction')
    end
  end
end
