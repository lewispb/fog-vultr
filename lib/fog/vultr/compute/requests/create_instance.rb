module Fog
  module Vultr
    class Compute
      class Real
        # Creates an instance from Vultr's attributes: region and plan, one
        # of os_id, snapshot_id, image_id, app_id or iso_id, and optionally
        # label, hostname, tags, sshkey_id, firewall_group_id, user_data
        # (Base64), enable_ipv6 and the rest of Vultr's create options.
        def create_instance(attributes)
          request method: :post, path: "instances", body: attributes, expects: 202
        end
      end

      class Mock
        SOURCES = [ "os_id", "snapshot_id", "image_id", "app_id", "iso_id" ]

        def create_instance(attributes)
          attributes = attributes.transform_keys(&:to_s)
          require_keys attributes, "region", "plan"
          raise Error, "400 Missing one of #{SOURCES.join(", ")}" if (attributes.keys & SOURCES).empty?

          instance = mocked_instance(attributes)
          data[:instances][instance["id"]] = instance
          response 202, "instance" => instance.merge("default_password" => "mocked-password")
        end

        private
          def mocked_instance(attributes)
            plan = PLANS.find { |candidate| candidate["id"] == attributes["plan"] } || PLANS.first

            {
              "id" => identifier, "label" => "", "hostname" => "", "tags" => [], "os_id" => 0, "firewall_group_id" => "",
              "main_ip" => "192.0.2.#{rand(1..254)}", "v6_main_ip" => "", "internal_ip" => "",
              "vcpu_count" => plan["vcpu_count"], "ram" => plan["ram"], "disk" => plan["disk"],
              "status" => "active", "power_status" => "running", "server_status" => "ok", "date_created" => now
            }.merge(attributes.slice("region", "plan", "label", "hostname", "tags", "os_id", "snapshot_id", "image_id", "app_id", "firewall_group_id"))
          end
      end
    end
  end
end
