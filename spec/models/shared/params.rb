# frozen_string_literal: true

RSpec.configure do |rspec|
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'with user_params', shared_context: :metadata do
  let(:valid_attrs) { { email: 'email@email.com', password: 'password' } }
end

RSpec.configure do |rspec|
  rspec.include_context 'with user_params', include_shared: true
end
