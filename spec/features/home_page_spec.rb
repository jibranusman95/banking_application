# frozen_string_literal: true

require 'rails_helper'

describe 'Home page features' do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:merchant) { FactoryBot.create(:merchant) }
  let!(:customer) { FactoryBot.create(:customer) }

  before do
    visit '/'
    within('#new_user') do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Log in'
    end
  end

  context 'when admin' do
    let(:user) { admin }

    it 'Check merchants and transactions buttons' do
      expect(page).to have_link 'Transactions'
      expect(page).to have_link 'Merchants'
    end
  end

  context 'when merchant' do
    let(:user) { merchant }

    it 'Check transactions buttons' do
      expect(page).to have_link 'Transactions'
    end
  end

  context 'when customer' do
    let(:user) { customer }

    it 'Check balance and transactions table' do
      expect(page).to have_text "Your balance: #{customer.customer_bank_account.balance}"
      expect(page).to have_table 'transactions_table'
    end
  end
end
