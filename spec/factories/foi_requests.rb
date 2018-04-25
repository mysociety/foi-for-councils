# frozen_string_literal: true

FactoryBot.define do
  factory :foi_request do
    body 'How much did you spend on cycling infrastructure last year?'
    contact
  end

  factory :unqueued_foi_request, parent: :foi_request do
    association :submission, :unqueued
  end

  factory :queued_foi_request, parent: :foi_request do
    association :submission, :queued
  end
end
