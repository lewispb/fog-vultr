require "fog/core/collection"
require "fog/vultr/compute/models/ssh_key"

module Fog
  module Vultr
    class Compute
      class SshKeys < Fog::Collection
        model Fog::Vultr::Compute::SshKey

        def all
          load service.list_all(:list_ssh_keys, "ssh_keys")
        end

        def get(id)
          new service.get_ssh_key(id).body.fetch("ssh_key")
        rescue NotFound
          nil
        end
      end
    end
  end
end
