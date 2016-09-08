require 'spec_helper'
include WithRollback

describe 'Region model' do
  let(:region) { Region.where(eveid: 10000015, name: 'Venal').first_or_create }
  let(:system) { System.where(eveid: 30001291, region_eveid: region.eveid, name: 'Y-4CFK').first_or_create }
  let(:citadel) { Citadel.where(citadel_type: 'Astrahus', corporation: 'TMLK', system_eveid: system.eveid).first_or_create }

  describe 'associations' do
    context 'system' do
      it 'asscoiates' do
        expect(region).to be_present
        expect(system).to be_present
        expect(region.systems.first).to eq system
      end
    end
    context 'region to citadel' do
      it 'associates' do
        expect(system).to be_present
        expect(citadel).to be_present
        expect(region).to be_present
        expect(region.citadels.first).to eq citadel
      end
    end
  end

  describe 'parse_csv' do
    context 'is given a csv file' do
      it 'adds to the database' do
        Region.new.parse_csv
        expect(Region.count).not_to be(0)
      end
    end
    context 'test region name' do
      it 'returns Derelik' do
        Region.new.parse_csv
        expect(Region.first.name).to eq('Derelik')
      end
    end
  end
end
