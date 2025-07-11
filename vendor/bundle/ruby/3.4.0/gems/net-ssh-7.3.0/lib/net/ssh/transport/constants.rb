module Net
  module SSH
    module Transport
      module Constants
        #--
        # Transport layer generic messages
        #++

        DISCONNECT                = 1
        IGNORE                    = 2
        UNIMPLEMENTED             = 3
        DEBUG                     = 4
        SERVICE_REQUEST           = 5
        SERVICE_ACCEPT            = 6

        #--
        # Algorithm negotiation messages
        #++

        KEXINIT                   = 20
        NEWKEYS                   = 21

        #--
        # Key exchange method specific messages
        #++

        KEXDH_INIT                = 30
        KEXDH_REPLY               = 31

        KEXECDH_INIT              = 30
        KEXECDH_REPLY             = 31

        KEXDH_GEX_GROUP           = 31
        KEXDH_GEX_INIT            = 32
        KEXDH_GEX_REPLY           = 33
        KEXDH_GEX_REQUEST         = 34
      end
    end
  end
end
