class System < ActiveRecord::Base
  validates_presence_of :region_id, :system_id, :name

  belongs_to :region

  def parse_csv(csv_filename = nil)
    csv_filename ||= './lib/mapSolarSystems.csv'
    CSV.foreach(csv_filename, headers: true, header_converters: :symbol) do |row|
      System.create(region_id: row[0].to_i, system_id: row[2].to_i, name: row[3])
    end
  end
end