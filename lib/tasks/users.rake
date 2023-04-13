# frozen_string_literal: true

namespace :users do
  task :extract_from_csv, [:file_path] => :environment do |_t, args|
    if args.file_path.present?
      use_case = Users::ExtractFromCsv.perform(args.file_path)

      if use_case&.success?
        puts 'Successfully extracted all users'
      elsif use_case&.failure?
        puts 'Failed to extract any users due to the following_errors in rows:'
        use_case.errors.full_messages.each { |error| puts error }
      elsif use_case&.partial_success?
        puts 'Failed to extract some users due to the following errors in rows:'
        use_case.errors.full_messages.each { |error| puts error }
      end
    end
  end
end
