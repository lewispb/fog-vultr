module Fog
  module Vultr
    class Compute
      class Real
        def get_ssh_key(id)
          request method: :get, path: "ssh-keys/#{id}", expects: 200
        end
      end

      class Mock
        def get_ssh_key(id)
          response 200, "ssh_key" => find(:ssh_keys, id)
        end
      end
    end
  end
end
