require 'csv'

namespace :import do
  desc "Import data from CSV file"

  task merchant: :environment do
    CSV.foreach('./data/merchants.csv', headers: true) do |row|
      Merchant.create(row.to_h)
    end
  end

  task customer: :environment do
    CSV.foreach('./data/customers.csv', headers: true) do |row|
      Customer.create(row.to_h)
    end
  end

  task invoice: :environment do
    CSV.foreach('./data/invoices.csv', headers: true) do |row|
      Invoice.create(row.to_h)
    end
  end

  task item: :environment do
    CSV.foreach('./data/items.csv', headers: true) do |row|
      Item.create(row.to_h)
    end
  end

  task transaction: :environment do
    CSV.foreach('./data/transactions.csv', headers: true) do |row|
      Transaction.create(row.to_h)
    end
  end

  task invoice_item: :environment do
    CSV.foreach('./data/invoice_items.csv', headers: true) do |row|
      InvoiceItem.create(row.to_h)
    end
  end

  task all: :environment do
    CSV.foreach('./data/merchants.csv', headers: true) do |row|
      Merchant.create(row.to_h)
    end
    CSV.foreach('./data/customers.csv', headers: true) do |row|
      Customer.create(row.to_h)
    end
    CSV.foreach('./data/invoices.csv', headers: true) do |row|
      Invoice.create(row.to_h)
    end
    CSV.foreach('./data/items.csv', headers: true) do |row|
      Item.create(row.to_h)
    end
    CSV.foreach('./data/transactions.csv', headers: true) do |row|
      Transaction.create(row.to_h)
    end
    CSV.foreach('./data/invoice_items.csv', headers: true) do |row|
      InvoiceItem.create(row.to_h)
    end
  end
end
