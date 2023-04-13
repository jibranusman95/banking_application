# frozen_string_literal: true

RSpec.shared_examples 'failure' do
  it { expect(use_case).not_to be_success }
  it { expect(use_case).to be_failure }
end

RSpec.shared_examples 'success' do
  it { expect(use_case).to be_success }
  it { expect(use_case).not_to be_failure }
end

RSpec.shared_examples 'balance_verification' do
  it {
    use_case
    expect(customer.customer_bank_account.reload.balance).to eq(customer_balance)
  }

  it {
    use_case
    expect(merchant.merchant_account.reload.total_transaction_sum).to eq(merchant_balance)
  }
end
