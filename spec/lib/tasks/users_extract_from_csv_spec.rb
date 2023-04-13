# frozen_string_literal: true

require 'rails_helper'

describe 'rake users:extract_from_csv', type: :task do
  let(:file_path) { 'some_path' }
  let(:extractor_class) { Users::ExtractFromCsv }

  before do
    allow(extractor_class).to receive(:perform)
    Rake::Task['users:extract_from_csv'].reenable
  end

  it 'calls the extract users use case when file_path is passed' do
    Rake::Task['users:extract_from_csv'].invoke(file_path)
    expect(extractor_class).to have_received(:perform).with(file_path)
  end

  it 'does not call the extract users use case when file_path is not passed' do
    Rake::Task['users:extract_from_csv'].invoke
    expect(extractor_class).not_to have_received(:perform)
  end
end
