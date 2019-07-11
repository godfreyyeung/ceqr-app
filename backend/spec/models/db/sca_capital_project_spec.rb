require 'rails_helper'

RSpec.describe Db::ScaCapitalProject, type: :model do
  describe "attributes by version" do
    def test_version(version)
      Db::ScaCapitalProject.version = version
      db = Db::ScaCapitalProject.first

      expect(db.project_dsf).to be_a String
      expect(db.name).to be_a String
      expect(db.org_level).to be_a String

      expect(db.capacity).to be_an Integer
      expect(db.pct_ps).to be_a Float
      expect(db.pct_is).to be_a Float
      expect(db.pct_hs).to be_a Float
      expect(db.total_est_cost).to be_a Float
      expect(db.funding_current_budget).to be_a Float # this attribute should not
      expect(db.funding_previous).to be_a Float
      expect(db.pct_funded).to be_a Float

      expect(db.start_date).to be_a ActiveSupport::TimeWithZone
      expect(db.planned_end_date).to be_a ActiveSupport::TimeWithZone

      expect(db.guessed_pct.class).to be_in([TrueClass, FalseClass, NilClass])

      expect(db.geom.geometry_type).to be RGeo::Feature::Point
      expect(db.geom.srid).to eq(4326)
    end

    it "2018" do
      test_version(2018)
    end
  end

  describe "#sca_projects_intersecting_subdistrict_geom" do
    it "returns an array of SCA schools that match subdistrict" do
      subdistrict_pairs = ["(2,3)"]

      subdistricts = Db::SchoolSubdistrict.for_subdistrict_pairs(subdistrict_pairs)

      geometry = subdistricts.map {|x| x[:geom]}

      sca_schools = Db::ScaCapitalProject.sca_projects_intersecting_subdistrict_geom(geometry.first)

      expect(sca_schools[0].project_dsf).to eq('DSF0000424314')
    end
  end
end
