require "fog/vultr"

module Fog
  module Vultr
    # Vultr's compute API, v2 (https://www.vultr.com/api/).
    #
    #   compute = Fog::Compute.new(provider: "Vultr", vultr_api_key: ENV["VULTR_API_KEY"])
    #   compute.servers.all(tag: "ci")
    #
    # Settings: vultr_api_key (required); vultr_url, the API's base URL;
    # persistent, to keep the connection open between requests;
    # connection_options, handed to Excon; retry_delays, the seconds waited
    # before each retry of a request Vultr rate limits or fails with a 5xx
    # (default 1, 2 and 4).
    class Compute < Fog::Service
      requires :vultr_api_key
      recognizes :vultr_url, :persistent, :connection_options, :retry_delays

      model_path "fog/vultr/compute/models"
      model :server
      collection :servers
      model :flavor
      collection :flavors
      model :image
      collection :images
      model :region
      collection :regions
      model :snapshot
      collection :snapshots
      model :ssh_key
      collection :ssh_keys
      model :firewall_group
      collection :firewall_groups
      model :firewall_rule
      collection :firewall_rules

      request_path "fog/vultr/compute/requests"
      request :list_instances
      request :get_instance
      request :create_instance
      request :delete_instance
      request :start_instance
      request :halt_instance
      request :reboot_instance
      request :restore_instance
      request :list_plans
      request :list_regions
      request :list_region_availability
      request :list_os
      request :list_snapshots
      request :get_snapshot
      request :create_snapshot
      request :delete_snapshot
      request :list_ssh_keys
      request :get_ssh_key
      request :create_ssh_key
      request :delete_ssh_key
      request :list_firewall_groups
      request :get_firewall_group
      request :create_firewall_group
      request :delete_firewall_group
      request :list_firewall_rules
      request :create_firewall_rule
      request :delete_firewall_rule
    end
  end
end

require "fog/vultr/compute/paging"
require "fog/vultr/compute/real"
require "fog/vultr/compute/mock"
