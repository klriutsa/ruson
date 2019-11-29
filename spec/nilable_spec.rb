require 'spec_helper'

RSpec.describe Ruson::Nilable do
  class Item < Ruson::Base
    field :id, nilable: false
    field :name, nilable: true
    field :description
  end

  it 'is not raised NotNilException' do
    expect {
      Item.new({ id: 2 })
    }.not_to raise_error
    expect {
      Item.new({ id: 2, name: 'name' })
    }.not_to raise_error
    expect {
      Item.new({ id: 2, name: 'name', description: 'description' })
    }.not_to raise_error
    expect {
      Item.new('{"id":2,"name":"name","description":"description"}')
    }.not_to raise_error
  end

  it 'is raised NotNilException' do
    expect {
      Item.new({})
    }.to raise_error(Ruson::NotNilException)
    expect {
      Item.new({ name: 'name' })
    }.to raise_error(Ruson::NotNilException)
    expect {
      Item.new({ name: 'name', description: 'description' })
    }.to raise_error(Ruson::NotNilException)
    expect {
      Item.new('{"name":"name","description":"description"}')
    }.to raise_error(Ruson::NotNilException)
  end
end
