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

class Thought < ApplicationRecord
  include PgSearch
  
  belongs_to :user
  pg_search_scope :search_for, against: [:text], using: { tsearch: { any_word: true } }
  
  def api_response_json
    {
        'text' => text,
        'by' => user.username,
        'timestamp' => created_at.to_i
    }
  end
end
