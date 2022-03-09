# frozen_string_literal: true

module RequestSpecHelper
  def response_json
    body = JSON.parse(response.body, symbolize_names: true)
    body.try(:with_indifferent_access) || body
  end

  def common_headers
    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end

  def auth_headers(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  def auth_tokens(resource_owner_id = nil)
    Doorkeeper::OAuth::TokenResponse.new(
      create(:oauth_access_token, resource_owner_id: resource_owner_id)
    ).body.with_indifferent_access
  end

  def stub_current_user(user)
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(Api::V1::BaseController).to receive(:doorkeeper_authorize!)
    allow_any_instance_of(Api::V1::BaseController).to receive(:current_user).and_return(user)
    # rubocop:enable RSpec/AnyInstance
  end
end
