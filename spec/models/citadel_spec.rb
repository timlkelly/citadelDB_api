require 'spec_helper'
include WithRollback

describe 'Citadel model' do
  let(:valid_attributes) do 
    { 
      system: 'Y-4CFK',
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
      expect(Citadel.find_by(system: 'Y-4CFK')).to be_present
    end
  end

  describe 'api_hash' do
    context 'API request' do
      let(:killmail_fixture) { File.read('./spec/fixtures/api_hash.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:hash_target) do
        {   
          system: "93PI-4",
          region: "Pure Blind",
          citadel_type: "Astrahus",
          corporation: "GoonWaffe",
          alliance: "Goonswarm Federation",
          killed_at: DateTime.parse('2016.07.12 03:02:07').to_i
        }
      end
      it 'returns a correct hash' do
        temporarily do
          killmail.save_if_relevant
          expect(Citadel.first.api_hash).to eq(hash_target)
        end
      end
    end
  end
end
