class Maintenance < ApplicationRecord
  belongs_to :equipament

  enum maintenance_type: { repair: "repair", maintenance: "maintenance" }

  enum status: { in_progress: "in_progress", finished: "finished" }

  validates :period_start, :maintenance_type, presence: true
  validates :period_start, comparison: { less_than_or_equal_to: -> { Date.today } }
  validates :period_end, :maintenance_value, presence: true, on: :update
  validates :period_end, comparison: { less_than_or_equal_to: -> { Date.today } }, on: :update
  validates :period_end, comparison: { greater_than_or_equal_to: :period_start }, on: :update
  validates :maintenance_value, numericality: { greater_than: 0 }, on: :update

  scope :total_maintenance_value_for_current_year, -> {
    where(status: 'finished')
      .where('EXTRACT(YEAR FROM created_at) = ?', Date.current.year)
      .sum(:maintenance_value)
  }

end
