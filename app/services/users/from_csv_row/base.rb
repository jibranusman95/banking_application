# frozen_string_literal: true

module Users
  module FromCsvRow
    class Base < ApplicationService
      def initialize(row, row_index)
        @row = row.to_h.symbolize_keys
        @index = row_index
      end
    end
  end
end
