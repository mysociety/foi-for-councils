# frozen_string_literal: true

require 'mysociety/redis'

# `Redis#exists(key)` will return an Integer in redis-rb 4.3. `exists?` returns
# a boolean, you should use it instead. To opt-in to the new behavior now you
# can set Redis.exists_returns_integer =  true.
Redis.exists_returns_integer = true

Redis.current = MySociety::Redis.create
