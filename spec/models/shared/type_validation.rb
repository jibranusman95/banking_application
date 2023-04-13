# frozen_string_literal: true

RSpec.shared_examples 'type_verification' do
  it 'verifies invalid types not instantiable' do
    invalid_classes.each do |invalid_class|
      expect do
        described_class.create!(**valid_attrs, type: invalid_class)
      end.to raise_error(ActiveRecord::SubclassNotFound)
    end
  end

  it { expect(described_class.create!(**valid_attrs, type: valid_class)).to be_valid }
end
