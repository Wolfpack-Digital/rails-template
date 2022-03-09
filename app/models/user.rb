# frozen_string_literal: true

class User < ApplicationRecord
  PASSWORD_COMPLEXITY_REGEXP = /(?=.*?\w)(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/.freeze

  devise :database_authenticatable, :rememberable, :validatable, :recoverable, :confirmable

  validates :email, :first_name, :last_name, presence: true
  validate :password_complexity

  enum role: {

  }

  class << self
    def authenticate(email, password)
      user = User.find_for_authentication(email: email)
      user&.valid_password?(password) ? user : nil
    end
  end

  def tokens
    access_token = Doorkeeper::AccessToken.create!(
      resource_owner_id: id,
      expires_in: Doorkeeper.configuration.access_token_expires_in,
      use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?
    )
    Doorkeeper::OAuth::TokenResponse.new(access_token).body.with_indifferent_access
  end

  private

    def password_complexity
      return if password.blank? || password =~ PASSWORD_COMPLEXITY_REGEXP

      errors.add :password, :complexity_not_met
    end
end
