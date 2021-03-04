# frozen_string_literal: true

# == Schema Information
#
# Table name: foi_suggestions
#
#  id              :bigint           not null, primary key
#  clicks          :integer          default(0), not null
#  relevance       :decimal(7, 6)
#  request_matches :string
#  resource_type   :string
#  submissions     :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  foi_request_id  :bigint
#  resource_id     :bigint

##
# This model represents an suggested answer to an FOI requests.
#
class FoiSuggestion < ApplicationRecord
  belongs_to :foi_request, optional: true
  belongs_to :resource, polymorphic: true

  delegate :title, :url, :summary, :keywords, to: :resource

  def self.from_request(request)
    GenerateFoiSuggestion.from_request(request)
  end

  def self.statistics
    stats = select(
      'COUNT(*) AS shown',
      'SUM(CASE WHEN clicks <> 0 THEN 1 END) AS clicks',
      'SUM(CASE WHEN clicks > 0 AND submissions = 0 THEN 1 END) AS answers'
    ).to_a.first

    shown = stats.shown

    { shown: shown,
      click_rate: shown.zero? ? 0.0 : stats.clicks.to_f / shown,
      answer_rate: shown.zero? ? 0.0 : stats.answers.to_f / shown }
  end

  def self.submitted!
    transaction { all.find_each(&:submitted!) }
  end

  def submitted!
    increment!(:submissions) # rubocop:disable Rails/SkipsModelValidations
  end

  def clicked!
    increment!(:clicks) # rubocop:disable Rails/SkipsModelValidations
  end
end
