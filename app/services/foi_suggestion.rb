# frozen_string_literal: true

require 'set'
##
# Provides suggested resources based on the FOI request made by a user.
#
class FoiSuggestion
  # FIXME: This is a proof-of-concept; it will be really slow in production as
  # the site scales.
  def self.from_text(text)
    text = Set.new(text.split)
    suggestions = CuratedLink.all.select do |link|
      text.intersect?(Set.new(link.keywords))
    end
    suggestions.take(3)
  end
end
