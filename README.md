# fog-vultr

A [fog](https://github.com/fog/fog-core) provider for [Vultr](https://www.vultr.com)'s
compute API, v2: instances, plans, regions, operating systems, snapshots, SSH keys and
firewall groups.

## Install

```ruby
gem "fog-vultr", github: "lewispb/fog-vultr"
```

## Use

```ruby
require "fog/vultr"

compute = Fog::Compute.new(provider: "Vultr", vultr_api_key: ENV["VULTR_API_KEY"])

snapshot = compute.snapshots.all(description: "ci-linux-20261107").first
key = compute.ssh_keys.all.find { |ssh_key| ssh_key.name == "ci" }

server = compute.servers.create(
  region: "ewr", plan: "vc2-16c-64gb", snapshot_id: snapshot.id,
  label: "ci-1", tags: [ "ci" ], ssh_key_ids: [ key.id ], user_data: "#cloud-config\n"
)
server.wait_for { ready? }
server.public_ip_address

compute.servers.all(tag: "ci").each(&:destroy)
```

Attributes keep Vultr's names. A server is created in a `region` on a `plan` from one of
`os_id`, `snapshot_id`, `image_id` (a marketplace image), `app_id` or `iso_id`.
`user_data` is plain text, and fog-vultr Base64-encodes it for Vultr. `ready?` means
Vultr reports the server active, running and ok.

| Collection | Vultr | Notes |
|---|---|---|
| `servers` | instances | `all(tag:, label:, main_ip:, region:)`; `start`, `stop`, `reboot`, `snapshot(description)` |
| `flavors` | plans | `all(type:, os:)`; `os: "windows"` gives the plans Windows runs on |
| `regions` | regions | `available_plans(type:)` gives what a region can deploy now |
| `images` | operating systems | `windows?` |
| `snapshots` | snapshots | `all(description:)`; `ready?` once complete |
| `ssh_keys` | SSH keys | |
| `firewall_groups` | firewall groups | `rules` gives the group's `firewall_rules` |

Collections load every page of a list. Each request is also available on the service
(`compute.list_instances(tag: "ci")`), returning one page with Vultr's JSON as the body.

### Settings

| Setting | Default | |
|---|---|---|
| `vultr_api_key` | | Required. A key from the Vultr console's API settings. |
| `vultr_url` | `https://api.vultr.com` | |
| `persistent` | `false` | Keeps the connection open between requests. |
| `connection_options` | `{}` | Handed to Excon. |
| `retry_delays` | `[ 1, 2, 4 ]` | Seconds waited before each retry. |

A request Vultr rate limits (429) is retried whatever its method, since Vultr turned it
away unprocessed. A 5xx or a dropped connection is retried for GET, PUT and DELETE only,
so a create is never sent twice. Other errors raise `Fog::Vultr::Compute::NotFound` (404)
or `Fog::Vultr::Compute::Error`, with Vultr's message.

### Mocks

`Fog.mock!` swaps in an in-memory account per API key, with a few of Vultr's plans,
regions and operating systems. Servers are ready as soon as they're created and
snapshots complete at once.

## Develop

```sh
bundle install
bundle exec rake test
bundle exec rubocop
VULTR_API_KEY=... bin/smoke             # reads regions, plans and Windows images
VULTR_API_KEY=... bin/smoke --boot ewr  # also boots and destroys the smallest Ubuntu server
```

## License

MIT
