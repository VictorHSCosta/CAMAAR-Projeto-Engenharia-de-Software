require 'openssl'
require 'net/ssh/authentication/pub_key_fingerprint'

module OpenSSL
  # This class is originally defined in the OpenSSL module. As needed, methods
  # have been added to it by the Net::SSH module for convenience in dealing with
  # SSH functionality.
  class BN
    # Converts a BN object to a string. The format used is that which is
    # required by the SSH2 protocol.
    def to_ssh
      if zero?
        return [0].pack("N")
      else
        buf = to_s(2)
        if buf.getbyte(0)[7] == 1
          return [buf.length + 1, 0, buf].pack("NCA*")
        else
          return [buf.length, buf].pack("NA*")
        end
      end
    end
  end

  module PKey
    class PKey
      include Net::SSH::Authentication::PubKeyFingerprint
    end

    # This class is originally defined in the OpenSSL module. As needed, methods
    # have been added to it by the Net::SSH module for convenience in dealing
    # with SSH functionality.
    class DH
      # Determines whether the pub_key for this key is valid. (This algorithm
      # lifted more-or-less directly from OpenSSH, dh.c, dh_pub_is_valid.)
      def valid?
        return false if pub_key.nil? || pub_key < 0

        bits_set = 0
        pub_key.num_bits.times { |i| bits_set += 1 if pub_key.bit_set?(i) }
        return (bits_set > 1 && pub_key < p)
      end
    end

    # This class is originally defined in the OpenSSL module. As needed, methods
    # have been added to it by the Net::SSH module for convenience in dealing
    # with SSH functionality.
    class RSA
      # Returns "ssh-rsa", which is the description of this key type used by the
      # SSH2 protocol.
      def ssh_type
        "ssh-rsa"
      end

      alias ssh_signature_type ssh_type

      # Converts the key to a blob, according to the SSH2 protocol.
      def to_blob
        @blob ||= Net::SSH::Buffer.from(:string, ssh_type, :bignum, e, :bignum, n).to_s
      end

      # Verifies the given signature matches the given data.
      def ssh_do_verify(sig, data, options = {})
        digester =
          if options[:host_key] == "rsa-sha2-512"
            OpenSSL::Digest::SHA512.new
          elsif options[:host_key] == "rsa-sha2-256"
            OpenSSL::Digest::SHA256.new
          else
            OpenSSL::Digest::SHA1.new
          end

        verify(digester, sig, data)
      end

      # Returns the signature for the given data.
      def ssh_do_sign(data, sig_alg = nil)
        digester =
          if sig_alg == "rsa-sha2-512"
            OpenSSL::Digest::SHA512.new
          elsif sig_alg == "rsa-sha2-256"
            OpenSSL::Digest::SHA256.new
          else
            OpenSSL::Digest::SHA1.new
          end
        sign(digester, data)
      end
    end

    # This class is originally defined in the OpenSSL module. As needed, methods
    # have been added to it by the Net::SSH module for convenience in dealing
    # with SSH functionality.
    class DSA
      # Returns "ssh-dss", which is the description of this key type used by the
      # SSH2 protocol.
      def ssh_type
        "ssh-dss"
      end

      alias ssh_signature_type ssh_type

      # Converts the key to a blob, according to the SSH2 protocol.
      def to_blob
        @blob ||= Net::SSH::Buffer.from(:string, ssh_type,
                                        :bignum, p, :bignum, q, :bignum, g, :bignum, pub_key).to_s
      end

      # Verifies the given signature matches the given data.
      def ssh_do_verify(sig, data, options = {})
        sig_r = sig[0, 20].unpack("H*")[0].to_i(16)
        sig_s = sig[20, 20].unpack("H*")[0].to_i(16)
        a1sig = OpenSSL::ASN1::Sequence([
                                          OpenSSL::ASN1::Integer(sig_r),
                                          OpenSSL::ASN1::Integer(sig_s)
                                        ])
        return verify(OpenSSL::Digest::SHA1.new, a1sig.to_der, data)
      end

      # Signs the given data.
      def ssh_do_sign(data, sig_alg = nil)
        sig = sign(OpenSSL::Digest::SHA1.new, data)
        a1sig = OpenSSL::ASN1.decode(sig)

        sig_r = a1sig.value[0].value.to_s(2)
        sig_s = a1sig.value[1].value.to_s(2)

        sig_size = params["q"].num_bits / 8
        raise OpenSSL::PKey::DSAError, "bad sig size" if sig_r.length > sig_size || sig_s.length > sig_size

        sig_r = "\0" * (20 - sig_r.length) + sig_r if sig_r.length < 20
        sig_s = "\0" * (20 - sig_s.length) + sig_s if sig_s.length < 20

        return sig_r + sig_s
      end
    end

    # This class is originally defined in the OpenSSL module. As needed, methods
    # have been added to it by the Net::SSH module for convenience in dealing
    # with SSH functionality.
    class EC
      CurveNameAlias = {
        'nistp256' => 'prime256v1',
        'nistp384' => 'secp384r1',
        'nistp521' => 'secp521r1'
      }.freeze

      CurveNameAliasInv = {
        'prime256v1' => 'nistp256',
        'secp384r1' => 'nistp384',
        'secp521r1' => 'nistp521'
      }.freeze

      def self.read_keyblob(curve_name_in_type, buffer)
        curve_name_in_key = buffer.read_string

        unless curve_name_in_type == curve_name_in_key
          raise Net::SSH::Exception, "curve name mismatched (`#{curve_name_in_key}' with `#{curve_name_in_type}')"
        end

        public_key_oct = buffer.read_string
        begin
          curvename = OpenSSL::PKey::EC::CurveNameAlias[curve_name_in_key]
          group = OpenSSL::PKey::EC::Group.new(curvename)
          point = OpenSSL::PKey::EC::Point.new(group, OpenSSL::BN.new(public_key_oct, 2))
          asn1 = OpenSSL::ASN1::Sequence(
            [
              OpenSSL::ASN1::Sequence(
                [
                  OpenSSL::ASN1::ObjectId("id-ecPublicKey"),
                  OpenSSL::ASN1::ObjectId(curvename)
                ]
              ),
              OpenSSL::ASN1::BitString(point.to_octet_string(:uncompressed))
            ]
          )

          key = OpenSSL::PKey::EC.new(asn1.to_der)

          return key
        rescue OpenSSL::PKey::ECError
          raise NotImplementedError, "unsupported key type `#{type}'"
        end
      end

      # Returns the description of this key type used by the
      # SSH2 protocol, like "ecdsa-sha2-nistp256"
      def ssh_type
        "ecdsa-sha2-#{CurveNameAliasInv[group.curve_name]}"
      end

      alias ssh_signature_type ssh_type

      def digester
        if group.curve_name =~ /^[a-z]+(\d+)\w*\z/
          curve_size = Regexp.last_match(1).to_i
          if curve_size <= 256
            OpenSSL::Digest::SHA256.new
          elsif curve_size <= 384
            OpenSSL::Digest::SHA384.new
          else
            OpenSSL::Digest::SHA512.new
          end
        else
          OpenSSL::Digest::SHA256.new
        end
      end
      private :digester

      # Converts the key to a blob, according to the SSH2 protocol.
      def to_blob
        @blob ||= Net::SSH::Buffer.from(:string, ssh_type,
                                        :string, CurveNameAliasInv[group.curve_name],
                                        :mstring, public_key.to_bn.to_s(2)).to_s
        @blob
      end

      # Verifies the given signature matches the given data.
      def ssh_do_verify(sig, data, options = {})
        digest = digester.digest(data)
        a1sig = nil

        begin
          sig_r_len = sig[0, 4].unpack('H*')[0].to_i(16)
          sig_l_len = sig[4 + sig_r_len, 4].unpack('H*')[0].to_i(16)

          sig_r = sig[4, sig_r_len].unpack('H*')[0]
          sig_s = sig[4 + sig_r_len + 4, sig_l_len].unpack('H*')[0]

          a1sig = OpenSSL::ASN1::Sequence([
                                            OpenSSL::ASN1::Integer(sig_r.to_i(16)),
                                            OpenSSL::ASN1::Integer(sig_s.to_i(16))
                                          ])
        rescue StandardError
        end

        if a1sig.nil?
          return false
        else
          dsa_verify_asn1(digest, a1sig.to_der)
        end
      end

      # Returns the signature for the given data.
      def ssh_do_sign(data, sig_alg = nil)
        digest = digester.digest(data)
        sig = dsa_sign_asn1(digest)
        a1sig = OpenSSL::ASN1.decode(sig)

        sig_r = a1sig.value[0].value
        sig_s = a1sig.value[1].value

        Net::SSH::Buffer.from(:bignum, sig_r, :bignum, sig_s).to_s
      end

      class Point
        # Returns the description of this key type used by the
        # SSH2 protocol, like "ecdsa-sha2-nistp256"
        def ssh_type
          "ecdsa-sha2-#{CurveNameAliasInv[group.curve_name]}"
        end

        alias ssh_signature_type ssh_type

        # Converts the key to a blob, according to the SSH2 protocol.
        def to_blob
          @blob ||= Net::SSH::Buffer.from(:string, ssh_type,
                                          :string, CurveNameAliasInv[group.curve_name],
                                          :mstring, to_bn.to_s(2)).to_s
          @blob
        end
      end
    end
  end
end
