# frozen_string_literal: true

# == Schema Information
#
# Table name: curated_links
#
#  id           :bigint           not null, primary key
#  destroyed_at :datetime
#  keywords     :string
#  summary      :text
#  title        :string           not null
#  url          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null

##
# Resources added by staff that appear in the Suggestions to users.
#
class CuratedLink < ApplicationRecord
  has_many :foi_suggestions, as: :resource, dependent: :destroy

  validates :title, :url, presence: true

  scope :active, -> { where(destroyed_at: nil) }

  def soft_destroy
    update(destroyed_at: Time.zone.now)
  end
end
