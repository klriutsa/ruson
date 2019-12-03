require 'spec_helper'

RSpec.describe 'Querying' do
  before(:all) do
    Ruson.output_folder = './db/'

    @user1_name = FFaker::Name.name
    @user1 = Vehicle.create(name: @user1_name)
    @user2_name = FFaker::Name.name
    @user2 = Vehicle.create(name: @user2_name)
  end
  after(:all) { FileUtils.rm_rf('./db/') }

  describe 'search by ID' do
    describe 'using find' do
      context "searching a record which doesn't exist" do
        it 'should raise a Ruson::RecordNotFound error' do
          expect {
            user = Vehicle.find(999)
            expect(user).to be_nil
          }.to_not raise_error
        end
      end

      context 'searching existing records' do
        it 'should not raise error' do
          expect {
            Vehicle.find(1)
          }.to_not raise_error
        end

        it 'should return the Vehicle instance for the given ID' do
          vehicle = Vehicle.find(1)

          expected_vehicle = Vehicle.new(name: @user1_name).to_hash
          expected_vehicle[:id] = 1 # Forces the ID

          expect(vehicle.to_hash).to eq(expected_vehicle)

          vehicle = Vehicle.find(2)

          expected_vehicle = Vehicle.new(name: @user2_name).to_hash
          expected_vehicle[:id] = 2 # Forces the ID

          expect(vehicle.to_hash).to eq(expected_vehicle)
        end
      end
    end

    describe 'using find!' do
      context "searching a record which doesn't exist" do
        it 'should raise a Ruson::RecordNotFound error' do
          expect {
            Vehicle.find!(999)
          }.to raise_error(Ruson::RecordNotFound)
        end
      end

      context 'searching existing records' do
        it 'should not raise error' do
          expect {
            Vehicle.find!(1)
          }.to_not raise_error
        end

        it 'should return the Vehicle instance for the given ID' do
          user = Vehicle.find!(1)
          expect(user.to_hash).to eq(@user1.to_hash)

          user = Vehicle.find!(2)
          expect(user.to_hash).to eq(@user2.to_hash)
        end
      end
    end
  end
end
