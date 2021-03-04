# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  keywords      :string
#  resource_type :text
#  summary       :text
#  title         :string
#  url           :string
#  resource_id   :bigint

##
# Union of CuratedLink and PublishedRequest powered by a Postgres view.
#
class Resource < ApplicationRecord
  belongs_to :resource, polymorphic: true

  delegate :foi_suggestions, :id, :created_at, :updated_at, to: :resource
  delegate :shown, :click_rate, :answer_rate, to: :statistics

  def self.csv_columns
    %i[id type title url keywords
       shown click_rate answer_rate
       created_at updated_at]
  end

  def type
    resource_type.titleize
  end

  private

  def statistics
    @statistics ||= OpenStruct.new(foi_suggestions.statistics)
  end
end
