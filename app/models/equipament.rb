class Equipament < ApplicationRecord
  has_one_attached :image
  has_one_attached :image do |attachable|
    attachable.variant(:thumb, resize_to_limit: [325, 205])
    attachable.variant(:medium, resize_to_limit: [750, 550])
  end

  has_rich_text :description

  has_many :schedules

  has_many :maintenances

  enum status: { available: "available", unavailable: "unavailable", maintenance: "maintenance" }

  validates :name, :serial_number, :rent_value, :description, presence: true
  validates :rent_value, numericality: { greater_than: 0 }

  scope :total_count, -> { count }

  scope :available, -> { where(status: "available") }

  scope :maintenance, -> { where(status: "maintenance") }

  scope :filtered_and_ordered, lambda { |search|
    scope = where(status: %w[available maintenance])
    scope = scope.where("LOWER(name) LIKE ?", "%#{search.downcase}%") if search.present?
    scope.order(:name, :serial_number)
  }

  def self.availables(period_start, period_end)
    period_end ||= Date.new(2099, 12, 31)

    where.not(
      id: left_outer_joins(:schedules)
          .where(
            "(schedules.period_start, schedules.period_end) OVERLAPS (?, ?)",
            period_start,
            period_end
          ).where(schedules: { status: %w[pending in_progress] })
    )
  end

  attr_accessor :remove_image

  before_save :purge_image, if: -> { remove_image == "1" }

  private

  def purge_image
    image.purge
  end
end
