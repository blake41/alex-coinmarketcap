class HistoricalDatum < ApplicationRecord

  belongs_to :currency, :dependent => :destroy
  validates :date, :uniqueness => {:scope => :currency_id}
end
