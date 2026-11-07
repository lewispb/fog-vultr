require "test_helper"

class MockTest < VultrTest
  def setup
    Fog.mock!
    Fog::Vultr::Compute::Mock.reset
  end

  def teardown
    Fog.unmock!
  end

  def test_runs_a_server_from_a_snapshot_and_removes_it
    image = compute.servers.create(region: "ewr", plan: "vc2-16c-64gb", os_id: 2284)
    snapshot = image.snapshot("ci-linux")
    server = compute.servers.create(region: "ewr", plan: "vc2-16c-64gb", snapshot_id: snapshot.id, tags: [ "ci" ])

    assert server.ready?
    assert_equal [ server.id ], compute.servers.all(tag: "ci").map(&:id)

    server.destroy
    assert_nil compute.servers.get(server.id)
  end

  def test_restores_a_server_from_its_snapshot
    server = compute.servers.create(region: "ewr", plan: "vc2-16c-64gb", os_id: 501)
    snapshot = server.snapshot("windows-golden")

    assert server.restore(snapshot)
    assert_equal snapshot.id, compute.servers.get(server.id).snapshot_id
  end

  def test_pages_through_servers
    3.times { compute.create_instance(region: "ewr", plan: "vc2-16c-64gb", os_id: 2284) }

    body = compute.list_instances(per_page: 2).body
    assert_equal 2, body["instances"].size
    assert_equal 1, compute.list_instances(per_page: 2, cursor: body["meta"]["links"]["next"]).body["instances"].size
    assert_equal 3, compute.servers.all.size
  end

  def test_refuses_a_server_without_an_image
    assert_raises(Fog::Vultr::Compute::Error) { compute.create_instance(region: "ewr", plan: "vc2-16c-64gb") }
  end

  def test_keeps_firewall_rules_with_their_group
    group = compute.firewall_groups.create(description: "ci")
    group.rules.create(ip_type: "v4", protocol: "tcp", subnet: "0.0.0.0", subnet_size: 0, port: "22")

    assert_equal [ "22" ], group.rules.all.map(&:port)
    assert_equal 1, compute.firewall_groups.get(group.id).rule_count
  end

  def test_keeps_each_accounts_data_apart
    compute.ssh_keys.create(name: "ci", ssh_key: "ssh-ed25519 AAAA ci")
    other = Fog::Compute.new(provider: "Vultr", vultr_api_key: "other-key")

    assert_empty other.ssh_keys.all
  end
end
