# frozen_string_literal: true

module UseCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  module ClassMethods
    def perform(*args)
      new(*args).tap(&:perform)
    end
  end

  def perform
    raise NotImplementedError
  end

  def success?
    errors.none?
  end

  def failure?
    errors.any?
  end
end
