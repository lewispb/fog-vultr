require "test_helper"

class ServerTest < VultrTest
  def test_creates_a_server_with_encoded_user_data_and_ssh_keys
    stub = stub_request(:post, "#{API}/instances")
      .with(body: {
        "region" => "ewr", "plan" => "vc2-16c-64gb", "snapshot_id" => "5359435d", "label" => "ci-1", "tags" => [ "ci" ],
        "firewall_group_id" => "1d5a6c8f", "sshkey_id" => [ "3b8066a7" ], "user_data" => "I2Nsb3VkLWNvbmZpZwo="
      })
      .to_return(status: 202, body: JSON.generate("instance" => fixture(:pending_instance)))

    server = compute.servers.create(
      region: "ewr", plan: "vc2-16c-64gb", snapshot_id: "5359435d", label: "ci-1", tags: [ "ci" ],
      firewall_group_id: "1d5a6c8f", ssh_key_ids: [ "3b8066a7" ], user_data: "#cloud-config\n"
    )

    assert_requested stub
    assert_equal "cb676a46-66fd-4dfb-b839-443f2e6c0b60", server.id
    assert_equal "v8!Vultr-generated", server.default_password
  end

  def test_a_pending_server_is_not_ready_and_has_no_public_address
    server = compute.servers.new(fixture(:pending_instance))

    refute server.ready?
    assert_nil server.public_ip_address
  end

  def test_an_active_server_is_ready
    server = compute.servers.new(fixture(:instance))

    assert server.ready?
    assert_equal "203.0.113.10", server.public_ip_address
    assert_nil server.private_ip_address
    assert_equal Time.utc(2026, 11, 7, 19, 30), server.created_at.utc
  end

  def test_waits_for_a_server_to_become_ready
    stub_request(:get, "#{API}/instances/#{fixture(:instance)["id"]}")
      .to_return({ body: JSON.generate("instance" => fixture(:pending_instance)) }, { body: JSON.generate("instance" => fixture(:instance)) })
    server = compute.servers.new(fixture(:pending_instance))

    server.wait_for(5, 0) { ready? }

    assert_equal "203.0.113.10", server.public_ip_address
  end

  def test_requires_a_region_and_plan
    assert_raises(ArgumentError) { compute.servers.create(os_id: 2284) }
  end

  def test_will_not_save_a_server_twice
    assert_raises(Fog::Errors::Error) { compute.servers.new(fixture(:instance)).save }
  end

  def test_destroys_a_server
    stub = stub_vultr(:delete, "instances/#{fixture(:instance)["id"]}", status: 204)

    assert compute.servers.new(fixture(:instance)).destroy
    assert_requested stub
  end

  def test_starts_stops_and_reboots_a_server
    server = compute.servers.new(fixture(:instance))
    stubs = [ "start", "halt", "reboot" ].map { |action| stub_vultr(:post, "instances/#{server.id}/#{action}", status: 204) }

    server.start
    server.stop
    server.reboot

    stubs.each { |stub| assert_requested stub }
  end

  def test_snapshots_a_server
    server = compute.servers.new(fixture(:instance))
    stub = stub_request(:post, "#{API}/snapshots")
      .with(body: { "instance_id" => server.id, "description" => "ci-linux-20261107" })
      .to_return(status: 201, body: JSON.generate("snapshot" => fixture(:snapshot).merge("status" => "pending")))

    snapshot = server.snapshot("ci-linux-20261107")

    assert_requested stub
    refute snapshot.ready?
  end

  def test_get_returns_nil_for_a_missing_server
    stub_vultr :get, "instances/missing", status: 404, body: { "error" => "Invalid instance-id.", "status" => 404 }

    assert_nil compute.servers.get("missing")
  end
end
