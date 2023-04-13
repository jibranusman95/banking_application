# frozen_string_literal: true

class User < ApplicationRecord
  AVAILABLE_TYPES = %w[Admin Customer Merchant].freeze
  include TypeEnumable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :type, :email, :password, presence: true
  validates :email, format: { with: /\A\S+@.+\.\S+\z/ }
end
