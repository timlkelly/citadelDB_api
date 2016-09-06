class Region < ActiveRecord::Base
  validates_presence_of :eveid, :name

  has_many :systems

  def parse_csv(csv_filename = nil)
    csv_filename ||= './lib/mapRegions.csv'
    CSV.foreach(csv_filename, headers: true, header_converters: :symbol) do |row|
      Region.create(eveid: row[0].to_i, name: row[1])
    end
  end
end
