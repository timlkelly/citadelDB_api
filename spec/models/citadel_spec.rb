require 'spec_helper'
include WithRollback

# let(:killmail_fixture) {  }
it 'loaddss and shit' do
  pp JSON.parse(File.read('../fixtures/stuff.json'))
end

describe 'Citadel model' do
  let(:valid_attributes) do 
    { 
      kill_ids: [],
      system: 'Y-4CFK',
      nearest_celestial: '6NJ stargate',
      citadel_type: 'Astrahus',
      corporation: 'TMLK'
    }
  end

  it 'creates a new instance' do
    temporarily do  
      expect do
        Citadel.create(valid_attributes)
      end.to change(Citadel, :count).by 1
    end
  end

  it 'can be found in the database' do
    temporarily do
      Citadel.all.map(&:destroy)  
      expect(Citadel.count).to eq(0)
      Citadel.create(valid_attributes)
      expect(Citadel.find_by(kill_ids: 48)).to be_present
    end
  end

  xit 'killmail has relevant citadel data' do
  end

  xit 'killmail can be parsed' do
  end
end
