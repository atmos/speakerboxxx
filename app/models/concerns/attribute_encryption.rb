# Module for handling encrypting/descrypting strings to columns.
module AttributeEncryption
  extend ActiveSupport::Concern

  included do
  end

  # Things exposed to the included class as class methods
  module ClassMethods
    def rbnacl_secret
      ENV["RBNACL_SECRET"] ||
        raise("No RBNACL_SECRET environmental variable set")
    end

    def rbnacl_secret_bytes
      rbnacl_secret.unpack("m0").first
    end
  end

  def rbnacl_simple_box
    @rbnacl_simple_box ||=
      RbNaCl::SimpleBox.from_secret_key(self.class.rbnacl_secret_bytes)
  end

  def decrypt_value(value)
    rbnacl_simple_box.decrypt(Base64.decode64(value))
  rescue RbNaCl::CryptoError, NoMethodError
    nil
  end

  def encrypt_value(value)
    return if value.blank?
    Base64.encode64(rbnacl_simple_box.encrypt(value)).chomp
  end
end
