require "fog/core/model"

module Fog
  module Vultr
    class Compute
      class SshKey < Fog::Model
        identity :id

        attribute :name
        attribute :ssh_key, aliases: [ "public_key", :public_key ]
        attribute :created_at, aliases: "date_created", type: :time

        def save
          raise Fog::Errors::Error, "Resaving an existing object may create a duplicate" if persisted?

          requires :name, :ssh_key
          merge_attributes service.create_ssh_key(name: name, ssh_key: ssh_key).body.fetch("ssh_key")
          true
        end

        def destroy
          requires :id
          service.delete_ssh_key(id)
          true
        end
      end
    end
  end
end
