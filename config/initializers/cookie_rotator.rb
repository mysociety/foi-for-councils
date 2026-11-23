# frozen_string_literal: true

# The Rails 7.0 defaults derive cookie keys with SHA256. Keep reading cookies
# signed or encrypted with the old SHA1 keys, so sessions survive the upgrade.
Rails.application.config.after_initialize do
  Rails.application.config.action_dispatch.cookies_rotations.tap do |cookies|
    config = Rails.application.config.action_dispatch
    key_generator = ActiveSupport::KeyGenerator.new(
      Rails.application.secret_key_base,
      iterations: 1000, hash_digest_class: OpenSSL::Digest::SHA1
    )
    key_len = ActiveSupport::MessageEncryptor.key_len

    cookies.rotate :encrypted, key_generator.generate_key(
      config.authenticated_encrypted_cookie_salt, key_len
    )
    cookies.rotate :signed,
                   key_generator.generate_key(config.signed_cookie_salt)
  end
end
