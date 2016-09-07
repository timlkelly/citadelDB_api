require 'spec_helper'
include WithRollback

describe 'citadel_app' do
  def app
    Sinatra::Application
  end

  describe "GET '/'" do
    context 'response' do
      it 'should be successful' do
        temporarily do
          citadel_hash = { system: System.where(name: 'J124753').first, citadel_type: 'Astrahus', corporation: 'Infernal Refuge', alliance: 'Ded End Conglomerates', killed_at: nil }
          Citadel.create(system: System.where(name: '7RM-N0').first, citadel_type: 'Astrahus', corporation: 'Pandemic Horde Inc.', alliance: 'Pandemic Horde', killed_at: nil)
          Citadel.create(citadel_hash)
          get '/', page: 2, per_page: 1
          result = JSON.parse(last_response.body)
          expect(result.is_a?(Hash)).to be_truthy
          expect(last_response.status).to eq 200
          # expect(result['citadels']).to eq([JSON.parse(citadel_hash.to_json)])
        end
      end
    end
  end
  context 'headers' do
    it 'has correct headers' do
      temporarily do
        system1 = System.where(name: '7RM-N0').first
        system2 = System.where(name: 'J124753').first
        Citadel.create(system: system1, citadel_type: 'Astrahus', corporation: 'Pandemic Horde Inc.', alliance: 'Pandemic Horde', killed_at: nil)
        Citadel.create(system: system2, citadel_type: 'Astrahus', corporation: 'Infernal Refuge', alliance: 'Ded End Conglomerates', killed_at: nil)
        get '/', page: 2, per_page: 1
        expect(last_response.header['Link']).to eq("<http://example.org/?page=1&per_page=1>; rel=\"prev\",<http://example.org/?page=1&per_page=1>; rel=\"first\",<http://example.org/?page=2&per_page=1>; rel=\"last\"")
      end
    end
  end
  context 'pagination' do
    context 'receives invalid params' do
      it 'returns 200' do
        get '/', page: 10, abc: 123
        expect(last_response.status).to eq 200
      end
    end
  end
end
