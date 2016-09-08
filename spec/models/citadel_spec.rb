require 'spec_helper'
include WithRollback

describe 'Citadel model' do
  let(:region) { Region.where(eveid: 10000015, name: 'Venal').first_or_create }
  let(:system) { System.where(eveid: 30001291, region_eveid: region.eveid, name: 'Y-4CFK').first_or_create }
  let(:valid_attributes) do
    {
      system_eveid: system.eveid,
      citadel_type: 'Astrahus',
      corporation: 'TMLK'
    }
  end

  it 'creates a new instance' do
    temporarily do
      expect do
        test = Citadel.create(valid_attributes)
        puts test.errors.full_messages
      end.to change(Citadel, :count).by 1
    end
  end

  it 'can be found in the database' do
    temporarily do
      Citadel.all.map(&:destroy)
      expect(Citadel.count).to eq(0)
      Citadel.create(valid_attributes)
      expect(Citadel.find_by(corporation: 'TMLK')).to be_present
    end
  end

  describe 'validations' do
    let(:citadel) { Citadel.new }
    before do
      citadel.validate
    end

    it 'should require system_id' do
      expect citadel.errors.full_messages.include?('Requires system_eveid')
    end
    it 'should require citadel_type' do
      expect citadel.errors.full_messages.include?('Requires citadel_type')
    end
    it 'should require corporation' do
      expect citadel.errors.full_messages.include?('Requires corporation')
    end
  end

  describe 'associations' do
    let(:citadel) { Citadel.create(valid_attributes) }
    context 'system' do
      it 'associates' do
        expect(citadel).to be_present
        expect(citadel.system).to eq system
      end
    end
    context 'region' do
      it 'associates' do
        expect(citadel).to be_present
        expect(citadel.region).to eq region
      end
    end
  end

  describe 'api_hash' do
    context 'API request' do
      let(:killmail_fixture) { File.read('./spec/fixtures/api_hash.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:hash_target) do
        {
          system: '93PI-4',
          region: 'Pure Blind',
          citadel_type: 'Astrahus',
          corporation: 'GoonWaffe',
          alliance: 'Goonswarm Federation',
          killed_at: DateTime.parse('2016.07.12 03:02:07').to_i
        }
      end
      it 'returns a correct hash' do
        temporarily do
          System.create(eveid: 30001990, region_eveid: 10000023, name: '93PI-4')
          Region.create(eveid: 10000023, name: 'Pure Blind')
          killmail.save_if_relevant
          expect(Citadel.first.api_hash).to eq(hash_target)
        end
      end
    end
  end
end
