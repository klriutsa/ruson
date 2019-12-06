require 'spec_helper'

RSpec.describe Array do
  class ArrayObject < Ruson::Base
    field :items, class: Array
  end

  it 'casts nil to an empty array' do
    obj = ArrayObject.new(items: nil)
    expect(obj.items).to eq([])
  end

  it 'casts boolean as an array with the boolean' do
    obj = ArrayObject.new(items: true)
    expect(obj.items).to eq([true])
  end

  it 'casts string as an array with the string' do
    obj = ArrayObject.new(items: 'test')
    expect(obj.items).to eq(['test'])
  end

  it 'casts integer as an array with the integer' do
    obj = ArrayObject.new(items: 1)
    expect(obj.items).to eq([1])
  end

  it 'returns the given array' do
    obj = ArrayObject.new(items: ['Test', 1])
    expect(obj.items).to eq(['Test', 1])
  end
end
