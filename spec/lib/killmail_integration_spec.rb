require 'spec_helper'
include WithRollback

describe KillmailIntegration do
  # describe 'fetch_killmail' do
  #   context 'it receives a valid killmail' do
  #     fetch = KillmailIntegration.new
  #     json_data = fetch.fetch_killmail
  #     it 'has one package' do
  #       expect(json_data.first.first).to eq('package')
  #     end
  #   end
  # end
  describe 'parse_killmail' do
    let(:killmail_fixture) { File.read('./spec/fixtures/duplicate_killmail.json') }
    let(:killmail_fixture2) { File.read('./spec/fixtures/duplicate_killmail2.json') }
    let(:km1) { Killmail.new(killmail_json: killmail_fixture) }
    let(:km2) { Killmail.new(killmail_json: killmail_fixture2) }
    context 'citadel already exists' do
      it 'does not raise citadel count' do
        temporarily do
          km1.find_or_create_citadel
          fetcher = KillmailIntegration.new
          expect do
            fetcher.parse_killmail(killmail_fixture)
          end.to change(Citadel, :count).by 0
          expect(Citadel.count).to eq(1)
        end
      end
    end
    context 'recieves ship killmail' do
      let(:citadel_target) do
        {
          system: 'J120619',
          region: 'B-R00005',
          citadel_type: 'Astrahus',
          corporation: 'Robogen Inc',
          alliance: 'The Firesale Nation',
          killed_at: '2016-05-11 05:43:29'
        }
      end
      let(:shipmail_fixture) { File.read('./spec/fixtures/listen_ship_test.json')}
      it 'does not raise killmail count' do
        temporarily do
          Citadel.create(citadel_target)
          expect do
            KillmailIntegration.new.parse_killmail(shipmail_fixture)
          end.to change(Killmail, :count).by 0
        end
      end
    end
    context "citadel doesn't exist" do
      it 'creates a new citadel' do
        temporarily do
          fetcher = KillmailIntegration.new
          expect do
            fetcher.parse_killmail(killmail_fixture)
          end.to change(Citadel, :count).by 1
          expect(Citadel.count).to eq(1)
        end
      end
    end
    context 'receives valid data' do
      it 'saves_if_relevant' do
        temporarily do
          fetcher = KillmailIntegration.new
          expect do
            fetcher.parse_killmail(killmail_fixture)
          end.to change(Killmail, :count).to eq(1)
        end
      end
    end
  end
  # describe 'json_to_killmail' do
  #   let(:url) { ['https://zkillboard.com/api/kills/shipTypeID/35832/page/1/'] }
  #   context 'it receives json with multiple Killmails' do
  #     it 'creates multiple killmail objects' do
  #       temporarily do
  #         KillmailIntegration.new.json_to_killmail(url)
  #         expect(Killmail.count).to be > 1
  #         expect(Citadel.count).to be > 1
  #       end
  #     end
  #   end
  # end
  describe 'create_url_array' do
    context 'creates urls for past api requests' do
      it 'returns the first url' do
        expect(KillmailIntegration.new.create_url_array.first).to eq('https://zkillboard.com/api/kills/shipTypeID/35832/page/1/')
      end
    end
  end
end
