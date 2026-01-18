class Task < ApplicationRecord
  belongs_to :project

  validates :title, presence: true
  validates :status, inclusion: { in: %w[pending in_progress completed] }
end

