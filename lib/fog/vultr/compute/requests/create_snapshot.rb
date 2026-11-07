module Fog
  module Vultr
    class Compute
      class Real
        # Snapshots an instance: instance_id and an optional description.
        def create_snapshot(attributes)
          request method: :post, path: "snapshots", body: attributes, expects: 201
        end
      end

      class Mock
        def create_snapshot(attributes)
          attributes = attributes.transform_keys(&:to_s)
          instance = find(:instances, attributes.fetch("instance_id") { raise Error, "400 Missing instance_id" })

          snapshot = {
            "id" => identifier, "description" => attributes.fetch("description", ""), "status" => "complete",
            "size" => instance["disk"] * 1024**3, "compressed_size" => instance["disk"] * 1024**3 / 4,
            "os_id" => instance["os_id"], "app_id" => 0, "date_created" => now
          }
          data[:snapshots][snapshot["id"]] = snapshot
          response 201, "snapshot" => snapshot
        end
      end
    end
  end
end
