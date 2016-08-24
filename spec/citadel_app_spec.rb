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
          citadel_hash = { system: 'J124753', citadel_type: 'Astrahus', corporation: 'Infernal Refuge', alliance: 'Ded End Conglomerates', region: 'C-R00009', killed_at: nil }
          Citadel.create(system: '7RM-N0', citadel_type: 'Astrahus', corporation: 'Pandemic Horde Inc.', alliance: 'Pandemic Horde', region: 'Pure Blind', killed_at: nil)
          Citadel.create(citadel_hash)
          get '/', page: 2, per_page: 1
          result = JSON.parse(last_response.body)
          expect(result.is_a?(Hash)).to be_truthy
          expect(result['citadels']).to eq([JSON.parse(citadel_hash.to_json)])
        end
      end
    end
  end
  context 'headers' do
    it 'has correct headers' do
      temporarily do
        Citadel.create(system: '7RM-N0', citadel_type: 'Astrahus', corporation: 'Pandemic Horde Inc.', alliance: 'Pandemic Horde', region: 'Pure Blind', killed_at: nil)
        Citadel.create(system: 'J124753', citadel_type: 'Astrahus', corporation: 'Infernal Refuge', alliance: 'Ded End Conglomerates', region: 'C-R00009', killed_at: nil)
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
