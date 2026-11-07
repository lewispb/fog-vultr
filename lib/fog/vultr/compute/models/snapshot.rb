require "fog/core/model"

module Fog
  module Vultr
    class Compute
      # A snapshot of an instance's disk, to create servers from by
      # snapshot_id. size and compressed_size are in bytes.
      class Snapshot < Fog::Model
        identity :id

        attribute :description
        attribute :status
        attribute :size, type: :integer
        attribute :compressed_size, type: :integer
        attribute :os_id, type: :integer
        attribute :app_id, type: :integer
        attribute :created_at, aliases: "date_created", type: :time

        attribute :instance_id

        def save
          raise Fog::Errors::Error, "Resaving an existing object may create a duplicate" if persisted?

          requires :instance_id
          merge_attributes service.create_snapshot({ instance_id: instance_id, description: description }.compact).body.fetch("snapshot")
          true
        end

        def destroy
          requires :id
          service.delete_snapshot(id)
          true
        end

        def ready?
          status == "complete"
        end
      end
    end
  end
end
