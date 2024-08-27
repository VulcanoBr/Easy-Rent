class Schedule < ApplicationRecord
  enum status: { pending: "pending", inprogress: "inprogress", done: "done" }

  belongs_to :equipament
  belongs_to :order, optional: true
end
