module Fog
  module Vultr
    class Compute
      class Real
        # Adds a public key to the account: name and ssh_key.
        def create_ssh_key(attributes)
          request method: :post, path: "ssh-keys", body: attributes, expects: 201
        end
      end

      class Mock
        def create_ssh_key(attributes)
          attributes = attributes.transform_keys(&:to_s)
          require_keys attributes, "name", "ssh_key"

          ssh_key = attributes.slice("name", "ssh_key").merge("id" => identifier, "date_created" => now)
          data[:ssh_keys][ssh_key["id"]] = ssh_key
          response 201, "ssh_key" => ssh_key
        end
      end
    end
  end
end
