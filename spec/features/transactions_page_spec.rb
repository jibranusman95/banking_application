# frozen_string_literal: true

require 'rails_helper'

describe 'Transaction page features' do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:merchant) { FactoryBot.create(:merchant) }

  before do
    visit '/'
    within('#new_user') do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Log in'
    end

    click_link 'Transactions'
  end

  context 'when admin' do
    let(:user) { admin }

    it 'Check transactions table and title' do
      expect(page).to have_text 'All Transactions'
      expect(page).to have_table 'transactions_table'
    end
  end

  context 'when merchant' do
    let(:user) { merchant }

    it 'Check transactions table and title' do
      expect(page).to have_text 'Your Transactions'
      expect(page).to have_text "Total transaction sum: #{merchant.merchant_account.total_transaction_sum}"
      expect(page).to have_table 'transactions_table'
    end
  end
end
