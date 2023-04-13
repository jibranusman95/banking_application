# frozen_string_literal: true

require 'csv'

module Users
  class ExtractFromCsv
    include UseCase

    CREATORS = {
      'admin' => FromCsvRow::AdminCreator,
      'merchant' => FromCsvRow::MerchantCreator
    }.freeze

    def initialize(file_path)
      @file_path = file_path
    end

    def perform
      @rows = CSV.parse(File.read(@file_path), headers: true)

      @rows.each_with_index do |row, index|
        result = CREATORS[row['user_type']].call(row, index + 1)

        errors.add(:base, result) unless result == true
      end
    end

    def failure?
      errors.size == @rows.size
    end

    def partial_success?
      errors.size.positive? && errors.size < @rows.size
    end
  end
end
