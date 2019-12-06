require 'spec_helper'

RSpec.describe Ruson::Converter do
  let(:post_json) { File.read('spec/support/post.json') }

  it 'convert object to hash' do
    obj = User.new(name: 'name')
    obj.name = 'ruby'
    expect(obj.to_hash).to eq(
      id: nil,
      name: 'ruby',
      url: nil
    )
  end

  it 'convert nested object to hash' do
    obj = Post.new(post_json)
    obj.tags.first.name = 'Perl'
    expect(obj.to_hash).to eq(
      id: 1,
      title: 'Ruson',
      user: {
        id: 1,
        name: 'klriutsa',
        url: 'https://github.com/klriutsa/ruson'
      },
      content: 'Json ORM for Ruby Object',
      picture: {
        id: 1,
        title: 'Ruson Picture',
        url: 'https://picsum.photos/200'
      },
      tags: [
        {
          id: 1,
          name: 'Perl'
        },
        {
          id: 2,
          name: 'Json'
        }
      ],
      status: :published
    )
  end

  it 'convert object to json' do
    obj = User.new(name: 'name')
    obj.name = 'ruby'
    expect(obj.to_json).to eq '{"id":null,"name":"ruby","url":null}'
  end

  it 'convert nested object to json' do
    obj = Post.new(post_json)
    obj.tags.first.name = 'Perl'
    expect(obj.to_json).to eq '{"id":1,"title":"Ruson","user":{"id":1,"name":"klriutsa","url":"https://github.com/klriutsa/ruson"},"content":"Json ORM for Ruby Object","picture":{"id":1,"title":"Ruson Picture","url":"https://picsum.photos/200"},"tags":[{"id":1,"name":"Perl"},{"id":2,"name":"Json"}],"status":"published"}'
  end
end
