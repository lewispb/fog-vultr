module Fog
  module Vultr
    class Compute
      class Real
        def list_ssh_keys(query = {})
          request method: :get, path: "ssh-keys", query: query, expects: 200
        end
      end

      class Mock
        def list_ssh_keys(query = {})
          page "ssh_keys", data[:ssh_keys].values, query
        end
      end
    end
  end
end
