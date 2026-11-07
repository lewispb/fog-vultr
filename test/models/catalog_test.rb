require "test_helper"

class CatalogTest < VultrTest
  def test_lists_plans_of_a_type_for_windows
    stub_vultr :get, "plans?per_page=500&type=vc2&os=windows", body: page("plans", fixture(:plans).first(1))

    flavor = compute.flavors.all(type: "vc2", os: "windows").first

    assert_equal "vc2-16c-64gb", flavor.id
    assert_equal 0.438, flavor.hourly_cost
    assert flavor.available_in?("ewr")
    refute flavor.available_in?("ord")
  end

  def test_gets_a_plan_from_every_type
    stub_vultr :get, "plans?per_page=500&type=all", body: page("plans", fixture(:plans))

    assert_equal 16, compute.flavors.get("voc-g-16c-64gb-320s-amd").vcpu_count
  end

  def test_lists_the_plans_a_region_can_deploy
    stub_vultr :get, "regions?per_page=500", body: page("regions", fixture(:regions))
    stub_vultr :get, "regions/ewr/availability?type=vc2", body: { "available_plans" => [ "vc2-16c-64gb" ] }

    assert_equal [ "vc2-16c-64gb" ], compute.regions.get("ewr").available_plans(type: "vc2")
  end

  def test_finds_windows_images
    stub_vultr :get, "os?per_page=500", body: page("os", fixture(:os))

    assert_equal [ 501 ], compute.images.all.select(&:windows?).map(&:id)
    assert_equal "Ubuntu 24.04 LTS x64", compute.images.get("2284").name
  end
end
