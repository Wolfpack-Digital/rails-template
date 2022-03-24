# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_access_token, class: 'Doorkeeper::AccessToken' do
    expires_in { Doorkeeper.configuration.access_token_expires_in }
    use_refresh_token { Doorkeeper.configuration.refresh_token_enabled? }

    after(:create) do |token|
      token.resource_owner_id ||= create(:user).id
    end
  end
end
