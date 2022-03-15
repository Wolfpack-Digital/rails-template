# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { 'password1!' }
    confirmed_at { 1.month.ago }
  end

  trait :unconfirmed do
    confirmed_at { nil }
  end
end
