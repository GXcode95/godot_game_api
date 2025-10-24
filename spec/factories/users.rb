FactoryBot.define do
  factory :user do
    nickname { Faker::Internet.username(specifier: 8) }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end


