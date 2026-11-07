require "test_helper"

class SnapshotTest < VultrTest
  def test_lists_snapshots_by_description
    stub_vultr :get, "snapshots?per_page=500&description=ci-linux-20261107", body: page("snapshots", [ fixture(:snapshot) ])

    snapshot = compute.snapshots.all(description: "ci-linux-20261107").first

    assert snapshot.ready?
    assert_equal 2284, snapshot.os_id
  end

  def test_destroys_a_snapshot
    stub = stub_vultr(:delete, "snapshots/#{fixture(:snapshot)["id"]}", status: 204)

    compute.snapshots.new(fixture(:snapshot)).destroy

    assert_requested stub
  end

  def test_requires_an_instance_to_snapshot
    assert_raises(ArgumentError) { compute.snapshots.create(description: "nothing") }
  end
end
