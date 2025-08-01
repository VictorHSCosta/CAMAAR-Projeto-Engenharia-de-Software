require 'net/ssh/transport/hmac/abstract'

module Net::SSH::Transport::HMAC
  # The SHA-256 Encrypt-Then-Mac HMAC algorithm. This has a mac and
  # key length of 32, and uses the SHA-256 digest algorithm.
  class SHA2_256_Etm < Abstract
    etm          true
    mac_length   32
    key_length   32
    digest_class OpenSSL::Digest::SHA256
  end
end
