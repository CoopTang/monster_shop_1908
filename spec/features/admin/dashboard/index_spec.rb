# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when I visit my dashboard' do
    it 'it shows all orders and the user for that order' do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      pull_toy = dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)

      user_1 = User.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, email: 'user_1@user.com', password: 'secure', role: 0)

      order_1 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 2)
      order_1.item_orders.create(order_id: order_1.id, item_id: pull_toy.id, quantity: 1, price: 100, merchant_id: dog_shop.id)

      order_2 = user_1.orders.create(name: 'User 2', address: '987 First', city: 'Dallas', state: 'TX', zip: 75_001, status: 3)
      order_2.item_orders.create(order_id: order_2.id, item_id: pull_toy.id, quantity: 1, price: 10, merchant_id: dog_shop.id)

      order_3 = user_1.orders.create(name: 'User 1', address: '123 Main', city: 'Denver', state: 'CO', zip: 80_233, status: 1)
      order_3.item_orders.create(order_id: order_3.id, item_id: pull_toy.id, quantity: 2, price: 15, merchant_id: dog_shop.id)

      order_4 = user_1.orders.create(name: 'User 2', address: '987 First', city: 'Dallas', state: 'TX', zip: 75_001, status: 0)
      order_4.item_orders.create(order_id: order_4.id, item_id: pull_toy.id, quantity: 2, price: 10, merchant_id: dog_shop.id)

      site_admin = User.create(name: 'Site Admin', address: '123 First', city: 'Denver', state: 'CO', zip: 80_233, email: 'site_admin@user.com', password: 'secure', role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(site_admin)

      visit admin_path

      within "#order-#{order_1.id}" do
        expect(page).to have_link(user_1.name)
        expect(page).to have_content(order_1.id)
        expect(page).to have_content(order_1.created_at)
        expect(page).to have_content(order_1.status)
      end

      within "#order-#{order_2.id}" do
        expect(page).to have_link(user_1.name)
        expect(page).to have_content(order_2.id)
        expect(page).to have_content(order_2.created_at)
        expect(page).to have_content(order_2.status)
      end

      within "#order-#{order_3.id}" do
        expect(page).to have_link(user_1.name)
        expect(page).to have_content(order_3.id)
        expect(page).to have_content(order_3.created_at)
        expect(page).to have_content(order_3.status)
      end

      within "#order-#{order_4.id}" do
        expect(page).to have_link(user_1.name)
        expect(page).to have_content(order_4.id)
        expect(page).to have_content(order_4.created_at)
        expect(page).to have_content(order_4.status)
      end
    end
  end
end
