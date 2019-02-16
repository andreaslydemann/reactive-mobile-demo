
FactoryBot.define do
  factory :thought do
    text { "Sample thought #{SecureRandom.uuid}" }
    association :user
  end
end