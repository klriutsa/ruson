# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'field name attribute' do
  context 'importing model data for a model with a named field' do
    it 'should import the named attribute from the JSON' do
      vehicle = Vehicle.new(
        name: 'Black Sims',
        price: 17.43,
        expiredAt: 1575608400.0
      )

      expect(vehicle.expired_at).to eq(Time.at(1575608400.0).to_datetime)
    end
  end

  context 'exporting model with a named field' do
    it 'should name the JSON attribute as the field name' do
      vehicle = Vehicle.new(
        name: 'Black Sims',
        price: 17.43,
        expired_at: 1575608400.0
      )

      expect(vehicle.to_hash).to eq(
        id: nil,
        name: 'Black Sims',
        price: 17.43,
        expiredAt: Time.at(1575608400.0).to_datetime
      )
    end
  end
end
