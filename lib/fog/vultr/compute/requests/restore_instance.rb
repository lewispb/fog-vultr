module Fog
  module Vultr
    class Compute
      class Real
        # Reinstalls an instance's disk from a snapshot (snapshot_id) or a
        # backup (backup_id), keeping the instance, its address and its bill
        def restore_instance(id, attributes)
          request method: :post, path: "instances/#{id}/restore", body: attributes, expects: [ 200, 202, 204 ]
        end
      end

      class Mock
        def restore_instance(id, attributes)
          instance = find(:instances, id)
          snapshot = find(:snapshots, attributes.transform_keys(&:to_s).fetch("snapshot_id") { raise Error, "400 Missing snapshot_id" })
          instance.merge!("snapshot_id" => snapshot["id"], "os_id" => snapshot["os_id"])
          response 202, "status" => { "restore_type" => "snapshot_id", "restore_id" => snapshot["id"], "status" => "restoring" }
        end
      end
    end
  end
end
