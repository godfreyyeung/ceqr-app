require 'rails_helper'

RSpec.describe Db::EnrollmentPctBySd, type: :model do
  describe "attributes schemas" do
    it "version 2017" do
      Db::EnrollmentPctBySd.version = 2017
      db = Db::EnrollmentPctBySd.first

      expect(db.district).to be_an Integer
      expect(db.subdistrict).to be_an Integer
      expect(db.level).to be_a String
      expect(db.multiplier).to be_a Float
    end

    it "version 2018" do
      Db::EnrollmentPctBySd.version = 2018
      db = Db::EnrollmentPctBySd.first

      expect(db.district).to be_an Integer
      expect(db.subdistrict).to be_an Integer
      expect(db.level).to be_a String
      expect(db.multiplier).to be_a Float
    end
  end

  describe "#enrollment_pct_by_sd" do
    it "returns an array of future_enrollment_multipliers" do
      subdistricts = ["(2,1)"]

      future_enrollment_multipliers = Db::EnrollmentPctBySd.enrollment_pct_by_sd(subdistricts)

      expect(future_enrollment_multipliers[0].district).to eq(2)
      expect(future_enrollment_multipliers[0].subdistrict).to eq(1)
    end
  end

end
