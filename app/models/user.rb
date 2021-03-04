# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

##
# This model represents a user which has authenticate via OmniAuth.
#
class User < ApplicationRecord
  def self.find_or_create_with_omniauth(auth_hash)
    arguments = { provider: auth_hash.provider, uid: auth_hash.uid }

    User.find_or_create_by(arguments) do |user|
      user.email = auth_hash.info['email']
      user.name = auth_hash.info['name']
    end
  end
end
