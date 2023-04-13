# frozen_string_literal: true

module TypeEnumable
  extend ActiveSupport::Concern

  included do
    validates_inclusion_of :type, in: self::AVAILABLE_TYPES, allow_nil: false

    self::AVAILABLE_TYPES.each do |available_type|
      define_method "#{available_type.split(/(?=[A-Z])/).join('_').downcase}?" do
        type == available_type
      end
    end
  end
end
