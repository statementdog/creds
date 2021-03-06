require "creds/version"
require "creds/plain_configuration"

require "active_support/core_ext/module/delegation"
require "active_support/encrypted_configuration"

require "creds/railtie" if defined?(Rails)

class Creds
  delegate_missing_to :configuration

  def initialize(file_path, key_path: "config/master.key", env_key: "RAILS_MASTER_KEY", raise_if_missing_key: true, env: nil)
    @file_path            = file_path
    @key_path             = key_path
    @env_key              = env_key
    @raise_if_missing_key = raise_if_missing_key
    @env                  = env
  end

  def configuration
    @configuration ||= if @file_path.end_with?(".enc")
      ActiveSupport::EncryptedConfiguration.new(
        config_path: @file_path,
        key_path: @key_path,
        env_key: @env_key,
        raise_if_missing_key: @raise_if_missing_key
      )
    else
      Creds::PlainConfiguration.new(@file_path, env: @env)
    end
  end
end
