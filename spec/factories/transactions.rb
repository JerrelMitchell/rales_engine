FactoryBot.define do
  factory :transaction do
    invoice 1
    credit_card_number 123456789
    credit_card_expiration_date nil
    result "successful"
  end
end
