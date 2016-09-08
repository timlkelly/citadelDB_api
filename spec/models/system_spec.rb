require 'spec_helper'
include WithRollback

describe 'System model' do
  let(:region) { Region.where(eveid: 10000015, name: 'Venal').first_or_create }
  let(:system) { System.where(eveid: 30001291, region_eveid: region.eveid, name: 'Y-4CFK').first_or_create }
  let(:citadel) { Citadel.where(citadel_type: 'Astrahus', corporation: 'TMLK', system_eveid: system.eveid).first_or_create }

  describe 'associations' do
    context 'system to region' do
      it 'assocaiates' do
        expect(region).to be_present
        expect(system).to be_present
        expect(system.region).to eq region
      end
    end
    context 'system to citadel' do
      it 'associates' do
        expect(system).to be_present
        expect(citadel).to be_present
        expect(system.citadels.first).to eq citadel
      end
    end
  end

  # describe 'parse_csv' do
  #   context 'is given a csv file' do
  #     it 'adds to the database' do
  #       System.new.parse_csv
  #       expect(System.count).not_to be(0)
  #     end
  #   end
  #   context 'test system name' do
  #     it 'returns Tanoo' do
  #       System.new.parse_csv
  #       expect(System.first.name).to eq('Tanoo')
  #     end
  #   end
  # end
end
