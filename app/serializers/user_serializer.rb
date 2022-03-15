# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :id, :first_name, :last_name, :email
  attribute :message, if: :message

  has_one :tokens, if: :with_auth_tokens?

  def with_auth_tokens?
    instance_options[:with_auth_tokens]
  end

  def message
    instance_options[:with_message]
  end
end
