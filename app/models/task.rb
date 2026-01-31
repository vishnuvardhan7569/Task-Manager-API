class Task < ApplicationRecord
  STATUSES = %w[not_started in_progress completed].freeze

  belongs_to :project

  validates :title, presence: true, uniqueness: { scope: :project_id, message: "must be unique within this project" }
  validates :description, length: { maximum: 2000 }, allow_nil: true
  validates :status, inclusion: { in: STATUSES }
end

