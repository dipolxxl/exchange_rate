require 'spec_helper'

describe 'routes for Currencies' do
  it 'routes /currencies/:id to currencies#show' do
    expect(get: '/currencies/usd.json', format: :json).to route_to(
      controller: 'currencies',
      action:     'show',
      format:     'json',
      id:         'usd'
    )
  end

  it 'routes /currencies to currencies#index' do
    expect(get: '/currencies.json', format: :json).to route_to(
      controller: 'currencies',
      action:     'index',
      format:     'json'
    )
  end

  it 'delete /currencies/:id should not be routable' do
    expect(delete: '/currencies/usd.json').not_to be_routable
  end

  it 'edit /currencies/:id should not be routable' do
    expect(get: '/currencies/usd.json/edit').not_to be_routable
  end

  it 'create /currencies should not be routable' do
    expect(post: '/currencies/').not_to be_routable
  end

  it 'update /currencies/:id should not be routable' do
    expect(post: '/currencies/usd.json').not_to be_routable
  end

  it 'new /currencies should not be routable' do
    pending
    # got #show -> expected #new
    expect(get: '/currencies/new').not_to be_routable
  end
end