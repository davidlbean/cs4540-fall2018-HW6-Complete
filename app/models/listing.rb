# == Schema Information
#
# Table name: listings
#
#  id                    :integer          not null, primary key
#  alerted_at            :datetime
#  description           :text
#  last_time_on_the_moon :datetime
#  price                 :float
#  pricing               :string
#  reviewed_at           :datetime
#  title                 :string
#  url                   :string
#  walks_like_a_duck     :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  listings_poll_id      :integer
#
# Indexes
#
#  index_listings_on_listings_poll_id  (listings_poll_id)
#

class Listing < ApplicationRecord
  has_many :listing_searches
  has_many :searches, through: :listing_searches
  has_many :users, through: :searches  
  belongs_to :listings_poll

  # one way of doing the scopes...
  scope :low_cost,    -> { where(price: 0..99.99) }
  scope :medium_cost, -> { where(price: 100..499.99) }
  scope :high_cost,   -> { where(price: 500..Float::INFINITY) }

  # ...and another way.
  # scope :low_cost,    -> { where("price >= ? and price < ?", 0, 100) }
  # scope :medium_cost, -> { where("price >= ? and price < ?", 100, 500) }
  # scope :high_cost,   -> { where("price >= ?", 500) }

  scope :reviewed, -> { where.not(reviewed_at: nil) }
  scope :not_reviewed, -> { where(reviewed_at: nil) }

  scope :alerted, -> { where.not(alerted_at: nil) }
  scope :not_alerted, -> { where(alerted_at: nil) }

  scope :newest_first, -> { order(updated_at: :desc)}

  def mark_as_reviewed
    self.reviewed_at = Time.now 
    self.save!
  end

  def mark_as_alerted
    self.alerted_at = Time.now 
    self.save!
  end

end
