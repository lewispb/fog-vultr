module Fog
  module Vultr
    class Compute
      class Real
        def delete_ssh_key(id)
          request method: :delete, path: "ssh-keys/#{id}", expects: 204
        end
      end

      class Mock
        def delete_ssh_key(id)
          find :ssh_keys, id
          data[:ssh_keys].delete(id)
          response 204
        end
      end
    end
  end
end
