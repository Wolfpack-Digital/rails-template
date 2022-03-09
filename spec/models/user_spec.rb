# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe 'ActiveRecord validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }

    context 'with invalid password complexity' do
      it { is_expected.not_to allow_value('short').for(:password) }
      it { is_expected.not_to allow_value('longerpassword').for(:password) }
    end

    context 'with valid password complexity' do
      it { is_expected.to allow_value('p@ssword123').for(:password) }
      it { is_expected.to allow_value('p4ssword!').for(:password) }
    end
  end

  describe '.authenticate' do
    subject { described_class.authenticate(email, auth_password) }

    let(:email) { 'test_user1@example.com' }
    let(:user_password) { 'password1!' }
    let(:auth_password) { user_password }

    context 'when user exists' do
      let!(:user) { create(:user, email: email, password: user_password, password_confirmation: user_password) }

      context 'with valid password' do
        it { is_expected.to eq(user) }
      end

      context 'with invalid password' do
        let(:auth_password) { 'invalid-password' }

        it { is_expected.to be_nil }
      end
    end

    context 'when user does not exist' do
      it { is_expected.to be_nil }
    end
  end
end
