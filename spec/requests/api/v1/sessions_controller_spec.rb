# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  describe 'POST /api/v1/sessions' do
    subject(:perform_request) { post api_v1_sessions_path, params: params.to_json, headers: common_headers }

    context 'with valid params' do
      let!(:user) { create(:user) }
      let(:params) do
        {
          user: {
            email: user.email,
            password: 'password1!'
          }
        }
      end
      let(:tokens) { auth_tokens }

      context 'when user confirmation is required' do
        let(:user) { create(:user, :unconfirmed) }
        let(:expected_response) do
          UserSerializer.new(user, with_message: I18n.t('devise.failure.unconfirmed')).to_json
        end

        it 'responds with user info and message to confirm account', :show_in_doc, doc_title: 'Unconfirmed account successful sign in' do
          perform_request
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_json[:message]).to eq('Error')
          expect(response_json[:errors]).to include(I18n.t('devise.failure.unconfirmed'))
        end
      end

      context 'when user confirmation is completed' do
        let(:expected_response) do
          UserSerializer.new(user, with_auth_tokens: true).to_json
        end

        before do
          # rubocop:disable RSpec/AnyInstance
          allow_any_instance_of(User).to receive(:tokens).and_return(tokens)
          # rubocop:enable RSpec/AnyInstance
        end

        it 'responds with user info and auth tokens', :show_in_doc, doc_title: 'Successful sign in' do
          perform_request
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(expected_response)
        end
      end
    end

    context 'with invalid params' do
      context 'when user account does not exist' do
        let(:params) do
          {
            user: {
              email: 'test_user1@example.com',
              password: 'password1!'
            }
          }
        end

        it 'responds with error', :show_in_doc do
          perform_request
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_json[:message]).to eq('Error')
          expect(response_json[:errors]).to include(I18n.t('devise.failure.invalid', authentication_keys: :email))
        end
      end

      context 'with invalid password' do
        let(:user) { create(:user) }
        let(:params) do
          {
            user: {
              email: user.email,
              password: 'invalid-password'
            }
          }
        end

        before do
          user
        end

        it 'responds with error' do
          perform_request
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_json[:message]).to eq('Error')
          expect(response_json[:errors]).to include(I18n.t('devise.failure.invalid', authentication_keys: :email))
        end
      end
    end
  end

  describe 'DELETE /api/v1/sessions' do
    subject(:perform_request) { delete api_v1_sessions_path, headers: { **common_headers, **auth_headers(token.token) } }

    let(:user) { create(:user) }
    let(:token) { create(:oauth_access_token, resource_owner_id: user.id) }

    context 'with valid token' do
      it 'revokes access token', :show_in_doc do
        expect { perform_request }.to change { token.reload.revoked_at }.from(nil)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid token' do
      let(:token) { instance_double('Doorkeeper::AccessToken', token: 'invalid-token') }

      it 'responds with 401', :show_in_doc do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
