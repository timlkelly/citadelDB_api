require 'spec_helper'
include WithRollback

describe 'Killmail model' do
  describe 'killed_at_datetime' do
    let(:killmail) { Killmail.new }
    context 'time string' do
      it "returns '2016.06.29 03:26:16' as a Time object" do
        expect(killmail.killed_at_datetime('2016.06.29 03:26:16')).to be_a(DateTime)
      end
    end
    context 'empty string' do
      it 'returns nil' do
        expect(killmail.killed_at_datetime).to eq(nil)
      end
    end
    context 'datetime' do
      it 'returns the datetime' do
        t = DateTime.parse('2016.06.29 03:26:16')
        expect(killmail.killed_at_datetime(t)).to be_a(DateTime)
      end
    end
  end

  describe 'killmail_data' do
    context 'with package' do
      let(:killmail_fixture) { File.read('./spec/fixtures/ship_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns data' do
        expect(killmail.killmail_data['killID']).to eq(50228036)
      end
    end
    context 'without package' do
      let(:killmail_fixture) { { 'killID' => 22 } }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns data' do
        expect(killmail.killmail_data['killID']).to eq(22)
      end
    end
    context 'null package' do
      let(:killmail_fixture) { File.read('./spec/fixtures/null_package.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns nil' do
        expect(killmail.killmail_data).to eq(nil)
      end
    end
  end

  describe 'system_id_lookup' do
    context 'given a valid system ID' do
      let(:killmail) { Killmail.new }
      it 'returns the system name' do
        expect(killmail.system_id_lookup(30001291)).to eq('Y-4CFK')
      end
    end
  end

  describe 'region_lookup' do
    context 'receives a systemID' do
      let(:killmail) { Killmail.new }
      it 'returns a region name' do
        expect(killmail.region_lookup(30001291)).to eq('Venal')
      end
    end
  end

  describe 'citadel_type_lookup' do
    context 'given shipTypeID' do
      let(:killmail) { Killmail.new }
      it 'returns the correct name' do
        expect(killmail.citadel_type_lookup('35832')).to eq('Astrahus')
      end
    end
  end

  describe 'citadel?' do
    context 'Astrahus killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Astrahus deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Fortizar killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/fortizar_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Fortizar deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/fortizar_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Keepstar killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/keepstar_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'Keepstar deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/keepstar_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'upwell killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/upwell_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'upwell deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/upwell_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel?).to eq true
      end
    end
    context 'is not a citadel' do
      let(:killmail_fixture) { File.read('./spec/fixtures/ship_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel?).to eq false
      end
    end
  end

  describe 'citadel_victim?' do
    context 'Listen: valid mail (citadel death)' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel_victim?).to eq(true)
      end
    end
    context 'Listen: invalid mail (citadel kill)' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel_victim?).to eq(false)
      end
    end
    context 'Listen: invalid mail (ship killmail)' do
      let(:killmail_fixture) { File.read('./spec/fixtures/ship_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel_victim?).to eq(false)
      end
    end
    context 'API pull: valid mail (citadel death)' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel_victim?).to eq(true)
      end
    end
    context 'API pull: invalid mail (citadel kill)' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel_victim?).to eq(false)
      end
    end
    context 'API pull: invalid mail (ship killmail)' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_ship.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel_victim?).to eq(false)
      end
    end
  end

  describe 'citadel_attacker?' do
    context 'Listen: citadel is attacker and is not first attacker' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel_attacker?).to eq(true)
      end
    end
    context 'Listen: citadel is not attacker' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel_attacker?).to eq(false)
      end
    end
    context 'Listen: ship killmail' do
      let(:shipmail_fixture) { File.read('./spec/fixtures/listen_ship_test.json') }
      let(:ship_killmail) { Killmail.new(killmail_json: shipmail_fixture) }
      it 'returns false' do
        expect(ship_killmail.citadel_attacker?).to eq(false)
      end
    end
    context 'API pull: citadel is attacker' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns true' do
        expect(killmail.citadel_attacker?).to eq(true)
      end
    end
    context 'API pull: citadel is not attacker' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel_attacker?).to eq(false)
      end
    end
    context 'API pull: ship killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_ship.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'returns false' do
        expect(killmail.citadel_attacker?).to eq(false)
      end
    end
  end

  describe 'generate_citadel_hash' do
    context 'Listen: with a valid killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:system) { System.find_by(name: 'E8-YS9') }
      let(:target) do
        {
          system: system,
          citadel_type: 'Astrahus',
          corporation: 'Forge Industrial Command',
          alliance: 'FUBAR.'
        }
      end
      it 'creates a hash for creating a new citadel' do
        expect(killmail.generate_citadel_hash).to eq target
      end
    end
    context 'Listen: with a valid deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:system) { System.where(name: 'Jaschercis').first }
      let(:target) do
        {
          system: system,
          citadel_type: 'Astrahus',
          corporation: 'Tokenada Technical Enterprises',
          alliance: nil,
          killed_at: DateTime.parse('2016.06.29 03:26:16')
        }
      end
      it 'creates a hash for creating a new citadel' do
        expect(killmail.generate_citadel_hash).to eq target
      end
    end
    context 'Listen: it receives a null package' do
      let(:killmail_fixture) { File.read('./spec/fixtures/null_package.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      it 'does not generate citadel' do
        expect do
          killmail.find_or_create_citadel
        end.to change(Citadel, :count).by 0
      end
    end
    context 'API pull: receives valid killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_killmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:system) { System.find_by(name: '6-4V20') }
      let(:target) do
        {
          system: system,
          citadel_type: 'Fortizar',
          corporation: 'Motiveless Malignity',
          alliance: nil
        }
      end
      it 'creates a hash to create a new citadel' do
        expect(killmail.generate_citadel_hash).to eq(target)
      end
    end
    context 'API pull: receives valid killmail with multiple attackers' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_killmail_multiple.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:system) { System.find_by(name: 'J115405') }
      let(:target) do
        {
          system: system,
          citadel_type: 'Keepstar',
          corporation: 'Hard Knocks Inc.',
          alliance: nil
        }
      end
      it 'creates a hash to create a new citadel' do
        expect([system].size).to eq 1
        expect(killmail.generate_citadel_hash).to eq(target)
      end
    end
    context 'API pull: receives valid deathmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_single.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:system) { System.find_by(name: '93PI-4') }
      let(:target) do
        {
          system: system,
          citadel_type: 'Astrahus',
          corporation: 'Pandemic Horde Inc.',
          alliance: 'Pandemic Horde',
          killed_at: DateTime.parse('2016-07-03 05:39:24')
        }
      end
      it 'creates a hash to create a new citadel' do
        expect([system].size).to eq 1
        expect(killmail.generate_citadel_hash).to eq(target)
      end
    end
  end

  describe 'find_or_create_citadel' do
    let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
    let(:killmail_fixture2) { File.read('./spec/fixtures/astrahus_killmail.json') }
    let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
    let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
    context 'Listen: citadel does not exist' do
      it 'creates a citadel instance' do
        temporarily do
          citadel = killmail.find_or_create_citadel
          expect(citadel.system.name).to eq('E8-YS9')
          expect(citadel.region.name).to eq('Immensea')
          expect(citadel.citadel_type).to eq('Astrahus')
          expect(citadel.corporation).to eq('Forge Industrial Command')
          expect(citadel.alliance).to eq('FUBAR.')
          expect(citadel.killed_at).to eq(nil)
          expect(Citadel.count).to eq(1)
        end
      end
    end
    context 'Listen: citadel already exists' do
      it 'it does not create duplicate instance' do
        temporarily do
          Citadel.create(killmail2.generate_citadel_hash)
          expect do
            citadel = killmail.find_or_create_citadel
            expect(citadel.system.name).to eq('E8-YS9')
            expect(citadel.region.name).to eq('Immensea')
            expect(citadel.citadel_type).to eq('Astrahus')
            expect(citadel.corporation).to eq('Forge Industrial Command')
            expect(citadel.alliance).to eq('FUBAR.')
            expect(citadel.killed_at).to eq(nil)
          end.to change(Citadel, :count).by 0
          expect(Citadel.count).to eq(1)
        end
      end
    end
    context 'Listen: citadel exists and is later destroyed' do
      let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail_predeathmail.json') }
      let(:deathmail_fixture) { File.read('./spec/fixtures/astrahus_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:deathmail) { Killmail.new(killmail_json: deathmail_fixture) }
      it 'updates the citadel' do
        temporarily do
          expect do
            killmail.find_or_create_citadel
            deathmail.find_or_create_citadel
          end.to change(Citadel, :count).by 1
          citadel = killmail.find_or_create_citadel
          expect(citadel.killed_at).to eq('2016.06.29 03:26:16')
        end
      end
    end
    context 'API pull: citadel does not exist' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_single.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      temporarily do
        it 'raises the citadel count by 1' do
          expect do
            citadel = killmail.find_or_create_citadel
            expect(citadel.system.name).to eq('93PI-4')
            expect(citadel.region.name).to eq('Pure Blind')
            expect(citadel.citadel_type).to eq('Astrahus')
            expect(citadel.corporation).to eq('Pandemic Horde Inc.')
            expect(citadel.alliance).to eq('Pandemic Horde')
            expect(citadel.killed_at).to eq(DateTime.parse('2016-07-03 05:39:24'))
          end.to change(Citadel, :count).by 1
        end
      end
    end
    context 'API pull: citadel already exists' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_single.json') }
      let(:killmail_fixture2) { File.read('./spec/fixtures/past_mail_single.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
      temporarily do
        it 'does not raise citadel count' do
          Citadel.create(killmail2.generate_citadel_hash)
          expect do
            citadel = killmail.find_or_create_citadel
            expect(citadel.system.name).to eq('93PI-4')
            expect(citadel.region.name).to eq('Pure Blind')
            expect(citadel.citadel_type).to eq('Astrahus')
            expect(citadel.corporation).to eq('Pandemic Horde Inc.')
            expect(citadel.alliance).to eq('Pandemic Horde')
            expect(citadel.killed_at).to eq(DateTime.parse('2016-07-03 05:39:24'))
          end.to change(Citadel, :count).by 0
        end
      end
    end
    context 'API pull: citadel exists and is later destroyed' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_killmail_updated.json') }
      let(:deathmail_fixture) { File.read('./spec/fixtures/past_deathmail.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:deathmail) { Killmail.new(killmail_json: deathmail_fixture) }
      temporarily do
        it 'updates the citadel' do
          expect do
            killmail.find_or_create_citadel
            deathmail.find_or_create_citadel
          end.to change(Citadel, :count).by 1
          citadel = killmail.find_or_create_citadel
          expect(citadel.killed_at).to eq(DateTime.parse('2016-07-07 00:49:58'))
        end
      end
    end
  end

  describe 'save_if_relevant' do
    let(:killmail_fixture) { File.read('./spec/fixtures/astrahus_killmail.json') }
    let(:ship_killmail_fixture) { File.read('./spec/fixtures/ship_killmail.json') }
    let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
    let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
    context 'Listen: new killmail' do
      it 'saves to db' do
        temporarily do
          citadel = killmail.find_or_create_citadel
          killmail.save_if_relevant
          expect(killmail.citadel_id).to eq(citadel.id)
          expect(killmail.killmail_eveid).to eq(killmail.killmail_data['killID'])
          expect(Killmail.count).to eq(1)
        end
      end
      context 'Listen: duplicate killmail' do
        it 'does not save' do
          temporarily do
            killmail.save_if_relevant
            killmail2.save_if_relevant
            expect(Killmail.count).to eq(1)
          end
        end
      end
      context 'Listen: not relevant report' do
        let(:ship_killmail) { Killmail.new(killmail_json: ship_killmail_fixture) }
        it 'does not save' do
          temporarily do
            expect do
              expect(ship_killmail.save_if_relevant).to be_falsey
            end.to change(Killmail, :count).by 0
          end
        end
      end
      context 'Listen: ship killmail from listen' do
        let(:system) { System.where(name: 'J120619').first }
        let(:citadel_target) do
          {
            system: system,
            citadel_type: 'Astrahus',
            corporation: 'Robogen Inc',
            alliance: 'The Firesale Nation',
            killed_at: '2016-05-11 05:43:29'
          }
        end
        let(:shipmail_fixture) { File.read('./spec/fixtures/ship_mail_listen.json') }
        let(:ship_killmail) { Killmail.new(killmail_json: shipmail_fixture) }
        it 'does not save' do
          temporarily do
            Citadel.create(citadel_target)
            expect do
              expect(ship_killmail.save_if_relevant).to be_falsey
            end.to change(Killmail, :count).by 0
          end
        end
      end
      context 'Listen: ship killmail from listen' do
        let(:system) { System.where(name: 'J120619').first }
        let(:citadel_target) do
          {
            system: system,
            citadel_type: 'Astrahus',
            corporation: 'Robogen Inc',
            alliance: 'The Firesale Nation',
            killed_at: '2016-05-11 05:43:29'
          }
        end
        let(:shipmail_fixture) { File.read('./spec/fixtures/listen_ship_test.json') }
        let(:ship_killmail) { Killmail.new(killmail_json: shipmail_fixture) }
        it 'does not save' do
          temporarily do
            Citadel.create(citadel_target)
            expect do
              expect(ship_killmail.save_if_relevant).to be_falsey
            end.to change(Killmail, :count).by 0
          end
        end
      end
    end
    context 'API pull: new killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_single.json') }
      let(:ship_killmail_fixture) { File.read('./spec/fixtures/past_mail_ship.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
      it 'saves to db' do
        temporarily do
          citadel = killmail.find_or_create_citadel
          killmail.save_if_relevant
          expect(killmail.citadel_id).to eq(citadel.id)
          expect(killmail.killmail_eveid).to eq(killmail.killmail_data['killID'])
          expect(Killmail.count).to eq(1)
        end
      end
    end
    context 'API pull: duplicate killmail' do
      let(:killmail_fixture) { File.read('./spec/fixtures/past_mail_single.json') }
      let(:ship_killmail_fixture) { File.read('./spec/fixtures/past_mail_ship.json') }
      let(:killmail) { Killmail.new(killmail_json: killmail_fixture) }
      let(:killmail2) { Killmail.new(killmail_json: killmail_fixture) }
      it 'does not save' do
        temporarily do
          killmail.save_if_relevant
          killmail2.save_if_relevant
          expect(Killmail.count).to eq(1)
        end
      end
    end
    context 'API pull: not relevant report' do
      let(:ship_killmail) { Killmail.new(killmail_json: ship_killmail_fixture) }
      it 'does not save' do
        temporarily do
          expect do
            expect(ship_killmail.save_if_relevant).to be_falsey
          end.to change(Killmail, :count).by 0
        end
      end
    end
  end
end
