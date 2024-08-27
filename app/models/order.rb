class Order < ApplicationRecord
  attr_accessor :credit_card_name, :credit_card_number, :credit_card_expiry_month, :credit_card_expiry_year,
                :credit_card_security_code, :pix_amount, :boleto_amount, :boleto_code,
                :total_rent_value, :tot_rent_value_display

  belongs_to :customer
  belongs_to :equipament
  has_one :schedule

  enum status: { pending: "pending", inprogress: "inprogress", canceled: "canceled", finished: "finished" }

  before_validation :generate_code, on: :create

  after_create :generate_schedule

  validates :period_start, :period_end, :rent_value, :tot_rent_value, :payment_method, presence: true
  validates :tot_rent_value, numericality: { greater_than: 0 }
  validates :rent_value, numericality: { greater_than: 0 }
  validates :period_start, :period_end, comparison: { greater_than_or_equal_to: -> { Date.today + 1 } }
  validates :period_end, comparison: { greater_than_or_equal_to: :period_start }

  with_options if: -> { payment_method == "cartao" } do
    validates :credit_card_name, presence: { message: "não pode ficar em branco" }
    validates :credit_card_number, presence: { message: "não pode ficar em branco" }
    validates :credit_card_expiry_month, presence: { message: "não pode ficar em branco" }
    validates :credit_card_expiry_year, presence: { message: "não pode ficar em branco" }
    validates :credit_card_security_code, presence: { message: "não pode ficar em branco" }
  end

  def self.current_year_completed_summary
    result = find_by_sql(["
      SELECT COUNT(*) AS total_orders, SUM(tot_rent_value) AS total_value
      FROM orders
      WHERE extract(year from created_at) = ?
      AND status NOT IN ('pending','canceled')
    ", Date.current.year]).first

    OpenStruct.new(total_orders: result.total_orders, total_value: result.total_value)
  end

  scope :in_progress_and_expired, lambda { |order_code = nil|
    query = where(status: "inprogress").where("period_end < ?", Date.today)
    query = query.where("order_code LIKE ?", "%#{order_code}%") if order_code.present?
    query
  }

  scope :pending_and_expired, lambda { |order_code = nil|
    query = where(status: "pending").where("period_end < ?", Date.today)
    query = query.where("order_code LIKE ?", "%#{order_code}%") if order_code.present?
    query
  }

  scope :pending_not_expired, lambda { |order_code = nil|
    query = where(status: "pending").where("period_start > ?", Date.today)
    query = query.where("order_code LIKE ?", "%#{order_code}%") if order_code.present?
    query
  }

  private

  def generate_schedule
    schedule = build_schedule(
      equipament:,
      period_start:,
      period_end: period_end || Date.new(2099, 12, 31)
    )
    schedule.save!
  end

  def creating_via_create_action?
    new_record? && self.class.connection.transaction_open?
  end

  def generate_code
    datetime_part = DateTime.now.strftime("%Y%m%d%H%M%S%L")
    random_number = rand(0..9)
    self.order_code = "#{datetime_part}#{random_number}"
  end
end
