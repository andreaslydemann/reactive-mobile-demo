# == Schema Information
#
# Table name: thoughts
#
#  id         :bigint(8)        not null, primary key
#  text       :string           default(""), not null
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


FactoryBot.define do
  factory :thought do
    text { "Sample thought #{SecureRandom.uuid}" }
    association :user
  end
end
