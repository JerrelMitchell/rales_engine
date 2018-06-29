require 'csv'

namespace :import do
  desc "Import merchants to database"
    pbar = ProgressBar.create(:title => "Merchants", :total => (CSV.read('./data/merchants.csv')).count, :format => "%a %b\u{263E}%i %p%% %t", :progress_mark  => ' ', :remainder_mark => "\u{FF65}", :starting_at => 1)
    task :merchants => :environment do
      CSV.foreach('./data/merchants.csv', { headers: true, header_converters: :symbol } ) do |row|
        pbar.increment
        Merchant.find_or_create_by(row.to_h)
      end
    end

    desc "Import customers to database"
    task :customers => :environment do
      pbar = ProgressBar.create(:title => "Customers", :total => (CSV.read('./data/customers.csv')).count, :format => "%a %b\u{263E}%i %p%% %t", :progress_mark  => ' ', :remainder_mark => "\u{FF65}", :starting_at => 1)
      CSV.foreach('./data/customers.csv', { headers: true, header_converters: :symbol } ) do |row|
        pbar.increment
        Customer.find_or_create_by(row.to_h)
      end
    end

    desc "Import invoices to database"
    task :invoices => :environment do
      pbar = ProgressBar.create(:title => "Invoices", :total => (CSV.read('./data/invoices.csv')).count, :format => "%a %b\u{263E}%i %p%% %t", :progress_mark  => ' ', :remainder_mark => "\u{FF65}", :starting_at => 1)
      CSV.foreach('./data/invoices.csv', { headers: true, header_converters: :symbol } ) do |row|
        pbar.increment
        Invoice.find_or_create_by(row.to_h)
      end
    end

    desc "Import transactions to database"
    task :transactions => :environment do
      pbar = ProgressBar.create(:title => "Transactions", :total => (CSV.read('./data/transactions.csv')).count, :format => "%a %b\u{263E}%i %p%% %t", :progress_mark  => ' ', :remainder_mark => "\u{FF65}", :starting_at => 1)
      CSV.foreach('./data/transactions.csv', { headers: true, header_converters: :symbol } ) do |row|
        pbar.increment
        Transaction.find_or_create_by(row.to_h)
      end
    end

    desc "Import items to database"
    task :items => :environment do
      pbar = ProgressBar.create(:title => "Items", :total => (CSV.read('./data/items.csv')).count, :format => "%a %b\u{263E}%i %p%% %t", :progress_mark  => ' ', :remainder_mark => "\u{FF65}", :starting_at => 1)
      CSV.foreach('./data/items.csv', { headers: true, header_converters: :symbol } ) do |row|
        pbar.increment
        Item.find_or_create_by(row.to_h)
      end
    end

    desc "Import invoice items to database"
    task :invoice_items => :environment do
      pbar = ProgressBar.create(:title => "Invoice Items", :total => (CSV.read('./data/invoice_items.csv')).count, :format => "%a %b\u{263E}%i %p%% %t", :progress_mark  => ' ', :remainder_mark => "\u{FF65}", :starting_at => 1)
      CSV.foreach('./data/invoice_items.csv', { headers: true, header_converters: :symbol } ) do |row|
        pbar.increment
        InvoiceItem.find_or_create_by(row.to_h)
      end
    end

  task all: :environment do
    Rake::Task['import:merchants'].invoke
    Rake::Task['import:customers'].invoke
    Rake::Task['import:invoices'].invoke
    Rake::Task['import:transactions'].invoke
    Rake::Task['import:items'].invoke
    Rake::Task['import:invoice_items'].invoke
  end
end
