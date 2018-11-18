class Like < ApplicationRecord
  belongs_to :user
  belongs_to :track, counter_cache: true
end
