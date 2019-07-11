require 'rails_helper'

RSpec.describe PublicSchoolsAnalysis, type: :model do
  before do
    @schoolSubdistrictMock = class_double('SchoolSubdistrict')
    allow(@schoolSubdistrictMock).to receive(:intersecting_with_bbls).and_return([
      {
        district: '15',
        subdistrict: '1'
      }
    ])

    allow(@schoolSubdistrictMock).to receive(:for_subdistrict_pairs).and_return([
      {
        district: '15',
        subdistrict: '1',
        school_choice_ps: false,
        school_choice_is: true,
        # geometry of district 15 subdistrict 1--> this subdistrict has both an lcgms school and an sca project
        geom: RGeo::Cartesian.preferred_factory(srid: 4326).parse_wkt("MULTIPOLYGON(((-74.015962 40.6586,-74.013974 40.657369,-74.012738 40.656625,-74.010493 40.655276,
          -74.008165 40.653856,-74.006224 40.652664,-74.003908 40.651266,-74.00171 40.64994,-73.999515 40.648612,-73.9973 40.647272,-73.995096 40.645946,-73.994527 40.645598,
          -73.9929 40.644618,-73.990496 40.643164,-73.989779 40.643645,-73.989059 40.644119,-73.98835 40.644562,-73.985284 40.645768,-73.983073 40.646625,-73.982309 40.646927,
          -73.981315 40.64732,-73.980363 40.647694,-73.97925 40.648122,-73.978368 40.64847,-73.977487 40.648812,-73.976603 40.649166,-73.975596 40.649865,-73.97461 40.650341,
          -73.973727 40.650685,-73.972656 40.651174,-73.972328 40.651398,-73.972253 40.651023,-73.97211 40.650664,-73.971909 40.650051,-73.971559 40.648823,-73.971396 40.648258,
          -73.97121 40.64762,-73.970841 40.646379,-73.97077 40.646111,-73.970546 40.645317,-73.970317 40.644538,-73.970089 40.643746,-73.970716 40.643678,-73.971648 40.643573,
          -73.97272 40.643456,-73.973814 40.643336,-73.974096 40.643305,-73.974375 40.643274,-73.975467 40.643153,-73.976396 40.643051,-73.977321 40.642948,-73.978249 40.642846,
          -73.979019 40.642972,-73.979442 40.642796,-73.979012 40.640795,-73.978925 40.640334,-73.979228 40.64057,-73.979863 40.640471,-73.980007 40.640209,-73.97991 40.639686,
          -73.979874 40.639518,-73.979677 40.638465,-73.980718 40.639089,-73.982922 40.640416,-73.983178 40.640169,-73.983502 40.639856,-73.984088 40.639298,-73.986292 40.640625,
          -73.986876 40.640069,-73.987456 40.639504,-73.98804 40.638947,-73.988621 40.638385,-73.989206 40.637824,-73.989789 40.637264,-73.990373 40.636705,-73.990956 40.636146,
          -73.991539 40.635582,-73.99212 40.635025,-73.994318 40.636354,-73.993738 40.636914,-73.993153 40.637476,-73.994536 40.638309,-73.995354 40.638805,-73.996227 40.639331,
          -73.997557 40.640137,-73.999757 40.641467,-74.00196 40.642799,-74.002545 40.642236,-74.003125 40.641675,-74.003712 40.641116,-74.004294 40.640556,-74.004876 40.639995,
          -74.005458 40.639435,-74.006042 40.638877,-74.006623 40.638315,-74.008067 40.639187,-74.008825 40.639645,-74.009825 40.640249,-74.010173 40.640459,-74.011029 40.640976,
          -74.013232 40.642305,-74.012649 40.642866,-74.014842 40.64419,-74.014907 40.64423,-74.014325 40.64479,-74.01437 40.644818,-74.016162 40.645895,-74.016257 40.645952,
          -74.016338 40.645996,-74.016411 40.646036,-74.016493 40.646078,-74.018673 40.647413,-74.020877 40.648743,-74.021362 40.64904,-74.024405 40.650922,-74.023834 40.651538,
          -74.023043 40.651029,-74.022637 40.651432,-74.021534 40.650733,-74.020994 40.651209,-74.024576 40.653554,-74.019552 40.657922,-74.01765 40.65958,-74.015962 40.6586)))")
      }
    ])

      allow(@schoolSubdistrictMock).to receive(:st_union_subdistricts).and_return(
        RGeo::Cartesian.preferred_factory(srid: 4326).parse_wkt("MULTIPOLYGON (((-74.015962 40.6586, -74.013974 40.657369, -74.012738 40.656625, -74.010493 40.655276, 
        -74.008165 40.653856, -74.006224 40.652664, -74.003908 40.651266, -74.00171 40.64994, -73.999515 40.648612, -73.9973 40.647272, -73.995096 40.645946, -73.994527 40.645598, 
        -73.9929 40.644618, -73.990496 40.643164, -73.989779 40.643645, -73.989059 40.644119, -73.98835 40.644562, -73.985284 40.645768, -73.983073 40.646625, -73.982309 40.646927, 
        -73.981315 40.64732, -73.980363 40.647694, -73.97925 40.648122, -73.978368 40.64847, -73.977487 40.648812, -73.976603 40.649166, -73.975596 40.649865, -73.97461 40.650341, 
        -73.973727 40.650685, -73.972656 40.651174, -73.972328 40.651398, -73.972253 40.651023, -73.97211 40.650664, -73.971909 40.650051, -73.971559 40.648823, -73.971396 40.648258, 
        -73.97121 40.64762, -73.970841 40.646379, -73.97077 40.646111, -73.970546 40.645317, -73.970317 40.644538, -73.970089 40.643746, -73.970716 40.643678, -73.971648 40.643573, 
        -73.97272 40.643456, -73.973814 40.643336, -73.974096 40.643305, -73.974375 40.643274, -73.975467 40.643153, -73.976396 40.643051, -73.977321 40.642948, -73.978249 40.642846, 
        -73.979019 40.642972, -73.979442 40.642796, -73.979012 40.640795, -73.978925 40.640334, -73.979228 40.64057, -73.979863 40.640471, -73.980007 40.640209, -73.97991 40.639686, 
        -73.979874 40.639518, -73.979677 40.638465, -73.980718 40.639089, -73.982922 40.640416, -73.983178 40.640169, -73.983502 40.639856, -73.984088 40.639298, -73.986292 40.640625, 
        -73.986876 40.640069, -73.987456 40.639504, -73.98804 40.638947, -73.988621 40.638385, -73.989206 40.637824, -73.989789 40.637264, -73.990373 40.636705, -73.990956 40.636146, 
        -73.991539 40.635582, -73.99212 40.635025, -73.994318 40.636354, -73.993738 40.636914, -73.993153 40.637476, -73.994536 40.638309, -73.995354 40.638805, -73.996227 40.639331, 
        -73.997557 40.640137, -73.999757 40.641467, -74.00196 40.642799, -74.002545 40.642236, -74.003125 40.641675, -74.003712 40.641116, -74.004294 40.640556, -74.004876 40.639995, 
        -74.005458 40.639435, -74.006042 40.638877, -74.006623 40.638315, -74.008067 40.639187, -74.008825 40.639645, -74.009825 40.640249, -74.010173 40.640459, -74.011029 40.640976, 
        -74.013232 40.642305, -74.012649 40.642866, -74.014842 40.64419, -74.014907 40.64423, -74.014325 40.64479, -74.01437 40.644818, -74.016162 40.645895, -74.016257 40.645952, 
        -74.016338 40.645996, -74.016411 40.646036, -74.016493 40.646078, -74.018673 40.647413, -74.020877 40.648743, -74.021362 40.64904, -74.024405 40.650922, -74.023834 40.651538, 
        -74.023043 40.651029, -74.022637 40.651432, -74.021534 40.650733, -74.020994 40.651209, -74.024576 40.653554, -74.019552 40.657922, -74.01765 40.65958, -74.015962 40.6586)))")
    )

    stub_const("#{Db}::SchoolSubdistrict", @schoolSubdistrictMock)
  end

  # bbl within district 1 subdistrict 15
  let(:project) { create(:project, build_year: 2026, bbls: [3007770001]) }
  let(:data_package) { create(:data_package) }
  let(:analysis) { create(:public_schools_analysis, project: project, data_package: data_package) }

## multipliers
  describe "should set multipliers on save and update" do
    it "sets multipliers correctly" do
      expect(analysis.multipliers['districts'][0]['csd']).to eq(15)
      expect(analysis.multipliers['districts'][0]['borocode']).to eq('bk')
    end
  end

## subdistricts_from_db
  describe "should set subdistricts on save and update" do
    it "sets subdistricts correctly" do
      expect(analysis.subdistricts_from_db[0]['district']).to eq('15')
      expect(analysis.subdistricts_from_db[0]['subdistrict']).to eq('1')
    end
  end

  ## es_school_choice & is_school_choice
    describe "should set es_school_choice and is_school_choice on save and update" do
      it "sets es_school_choice and is_school_choice correctly" do
        expect(analysis.es_school_choice).to eq(false)
        # expect(analysis.is_school_choice).to eq(true)
      end
    end

## bluebook
  describe "should set bluebook on save and update" do
    it "sets bluebook correctly" do
      expect(analysis.bluebook[0]['district']).to eq('15')
      expect(analysis.bluebook[0]['subdistrict']).to eq('1')
    end
  end

## lcgms
    describe "should set lcgms on save and update" do
      it "sets lcgms correctly" do
        expect(analysis.lcgms[0]['district']).to eq('15')
        expect(analysis.lcgms[0]['subdistrict']).to eq('1')
      end
    end

## sca_projects
    describe "should set sca projects on save and update" do
      it "sets sca projects correctly" do
        expect(analysis.sca_projects[0]['district']).to eq('15')
        expect(analysis.sca_projects[0]['subdistrict']).to eq('1')
      end
    end

## future_enrollment_multipliers
  describe "should set future_enrollment_multipliers on save and update" do
    it "sets future_enrollment_multipliers correctly" do
      expect(analysis.future_enrollment_multipliers[0]['district']).to eq('15')
      expect(analysis.future_enrollment_multipliers[0]['subdistrict']).to eq('1')
    end
  end

## hs_projections
  describe "should set hs_projections on save and update" do
    it "sets hs_projections correctly" do
      borough = analysis.hs_projections.map {|n| n['borough']}
      expect(borough).to eq(['brooklyn'])
    end
  end

## future_enrollment_projections
    describe "should set future_enrollment_projections on save and update" do
      it "sets future_enrollment_projections correctly" do
        expect(analysis.future_enrollment_projections[0]['district']).to eq('15')
      end
    end

## hs_students_from_housing
    describe "should set hs_students_from_housing on save and update" do
      it "sets hs_students_from_housing correctly" do
        # new_students in table sca_housing_pipeline_by_boro for Brooklyn is 4802
        expect(analysis.hs_students_from_housing).to eq(4802)
      end
    end

## future_enrollment_new_housing
    describe "should set future_enrollment_new_housing on save and update" do
      it "sets set future_enrollment_new_housing correctly" do
        expect(analysis.future_enrollment_new_housing[0]['district']).to eq('15')
        expect(analysis.future_enrollment_new_housing[0]['subdistrict']).to eq('1')
      end
    end

  ## doe_util_changes
  # TODO: this test can be made more specific
  describe "should set doe_util_changes on save and update" do
    it "sets set doe_util_changes correctly" do
      blubookBuildingIds = analysis.bluebook.map {|b| b['bldg_id']}
      lcmgsBuildingsIds = analysis.lcgms.map {|b| b['bldg_id']}

      allBuildingIds = (blubookBuildingIds + lcmgsBuildingsIds).uniq

      doeBuildingIds = analysis.doe_util_changes.map {|b| b['bldg_id']}.uniq # two items for district 15 subdistrict 1

      expect(allBuildingIds).to include(doeBuildingIds[0], doeBuildingIds[1])
    end
  end
end
