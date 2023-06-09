# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    render "#{current_user.type.downcase}s/home/index"
  end
end
