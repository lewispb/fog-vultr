require "fog/compute/models/server"

module Fog
  module Vultr
    class Compute
      # An instance. Attributes use Vultr's names: a server is created in a
      # region on a plan, from one of os_id, snapshot_id, image_id (a
      # marketplace image), app_id or iso_id.
      #
      #   server = compute.servers.create(
      #     region: "ewr", plan: "vc2-16c-64gb", snapshot_id: snapshot.id,
      #     label: "ci-1", tags: [ "ci" ], ssh_key_ids: [ key.id ], user_data: "#cloud-config\n"
      #   )
      #   server.wait_for { ready? }
      #
      # user_data is plain text; it's sent to Vultr Base64-encoded.
      class Server < Fog::Compute::Server
        CREATED = [
          :region, :plan, :os_id, :snapshot_id, :image_id, :app_id, :iso_id, :script_id, :label, :hostname, :tags,
          :firewall_group_id, :enable_ipv6, :disable_public_ipv4, :attach_vpc, :backups, :activation_email, :user_scheme
        ]

        identity :id

        attribute :label
        attribute :hostname
        attribute :region
        attribute :plan
        attribute :os
        attribute :os_id, type: :integer
        attribute :snapshot_id
        attribute :image_id
        attribute :app_id, type: :integer
        attribute :iso_id
        attribute :script_id
        attribute :tags, type: :array
        attribute :firewall_group_id
        attribute :status
        attribute :power_status
        attribute :server_status
        attribute :main_ip
        attribute :v6_main_ip
        attribute :internal_ip
        attribute :vcpu_count, type: :integer
        attribute :ram, type: :integer
        attribute :disk, type: :integer
        attribute :features, type: :array
        attribute :default_password
        attribute :created_at, aliases: "date_created", type: :time

        attribute :ssh_key_ids, type: :array
        attribute :user_data
        attribute :enable_ipv6, type: :boolean
        attribute :disable_public_ipv4, type: :boolean
        attribute :attach_vpc, type: :array
        attribute :backups
        attribute :activation_email, type: :boolean
        attribute :user_scheme

        def save
          raise Fog::Errors::Error, "Resaving an existing object may create a duplicate" if persisted?

          requires :region, :plan
          merge_attributes service.create_instance(creation_attributes).body.fetch("instance")
          true
        end

        def destroy
          requires :id
          service.delete_instance(id)
          true
        end

        def start
          requires :id
          service.start_instance(id)
          true
        end

        def stop
          requires :id
          service.halt_instance(id)
          true
        end

        def reboot
          requires :id
          service.reboot_instance(id)
          true
        end

        # Reinstalls the server's disk from a snapshot, keeping the server, its
        # address and its billed hour. It isn't ready again until Vultr has
        # copied the snapshot back.
        def restore(snapshot)
          requires :id
          service.restore_instance(id, snapshot_id: snapshot.respond_to?(:id) ? snapshot.id : snapshot)
          true
        end

        # Snapshots the server, returning the snapshot, which is pending
        # until Vultr has copied the disk
        def snapshot(description = nil)
          requires :id
          service.snapshots.create(instance_id: id, description: description)
        end

        def ready?
          status == "active" && power_status == "running" && server_status == "ok"
        end

        def public_ip_address
          main_ip unless main_ip.to_s.empty? || main_ip == "0.0.0.0"
        end

        def private_ip_address
          internal_ip unless internal_ip.to_s.empty?
        end

        private
          def creation_attributes
            attributes.slice(*CREATED).merge(sshkey_id: ssh_key_ids, user_data: encoded_user_data).compact
          end

          def encoded_user_data
            [ user_data ].pack("m0") if user_data
          end
      end
    end
  end
end
