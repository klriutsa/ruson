require 'spec_helper'

RSpec.describe Ruson::Converter do
  let(:text) { File.read('spec/support/example.json') }

  it 'convert object to hash' do
    obj = RusonBaseTestSubClass.new({ test_name: 'test' })
    obj.test_name = 'new_name'
    expect(obj.to_hash).to eq({ test_name: 'new_name' })
  end

  it 'convert nested object to hash' do
    obj = RusonBaseTestSubClass3.new(text)
    obj.objects.first.test_name = '100'
    expect(obj.to_hash).to eq({ object: { test_name: 'object_name' }, objects: [{ test_name: '100' }, { test_name: '2' }, { test_name: '3' }] })
  end

  it 'convert object to json' do
    obj = RusonBaseTestSubClass.new({ test_name: 'test' })
    obj.test_name = 'new_name'
    expect(obj.to_json).to eq '{"test_name":"new_name"}'
  end

  it 'convert nested object to json' do
    obj = RusonBaseTestSubClass3.new(text)
    obj.objects.first.test_name = '100'
    expect(obj.to_json).to eq '{"object":{"test_name":"object_name"},"objects":[{"test_name":"100"},{"test_name":"2"},{"test_name":"3"}]}'
  end
end
