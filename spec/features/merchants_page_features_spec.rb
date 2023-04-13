# frozen_string_literal: true

require 'rails_helper'

describe 'Merchant page features' do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:merchant) { FactoryBot.create(:merchant) }

  before do
    visit '/'
    within('#new_user') do
      fill_in 'user_email', with: admin.email
      fill_in 'user_password', with: 'password'
      click_button 'Log in'
    end

    click_link 'Merchants'
  end

  describe 'Merchant index page' do
    it 'Check merchants table and title' do
      expect(page).to have_text 'Merchants'
      expect(page).to have_table 'merchants_table'
      expect(page).to have_content merchant.email
    end
  end
end
