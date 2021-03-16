# frozen_string_literal: true

FactoryBot.define do
  factory :published_request do
    reference { 'FOI-001' }
    title { 'Business Rates' }

    summary do
      <<-TEXT.strip_heredoc.chomp.squish
      Initial FOI Request
      Dear Redacted
      Automated acknowledgement.
      Dear Redacted
      FOI Response
      TEXT
    end

    keywords { 'Business, business rates' }
    url { 'http://foi.infreemation.co.uk/redirect/hackney?id=1' }
    published_at { Date.parse('2018-04-23') }
    api_created_at { Date.parse('2018-01-01') }

    payload do
      { ref: 'FOI-001' }
    end

    case_management { 'CaseManagement::Fake' }

    factory :published_request_with_suggestions do
      after(:create) do |published_request, _evaluator|
        create_list(:foi_suggestion, 3, resource: published_request)
      end
    end
  end
end
