class Transaction < ApplicationRecord
  belongs_to :invoice
  belongs_to :customer, optional: true

  scope :successful,      -> { where(result: 'success') }
  scope :not_successful,  -> { where(result: 'failed') }

  default_scope { order(:id) }
end
