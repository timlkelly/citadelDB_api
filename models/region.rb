class Region < ActiveRecord::Base
  validates_presence_of :region_id, :name

  has_many :systems

  def parse_csv
    CSV.foreach('./lib/mapRegions.csv', headers: true, header_converters: :symbol) do |row|
      Region.create(region_id: row[0].to_i, name: row[1])
    end
  end
end
