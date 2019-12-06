require 'spec_helper'

RSpec.describe 'Querying' do
  before(:all) do
    Ruson.output_folder = './db/'

    @vehicle1_name = FFaker::Name.name
    @vehicle1 = Vehicle.create(name: @vehicle1_name)
    @vehicle2_name = FFaker::Name.name
    @vehicle2 = Vehicle.create(name: @vehicle2_name)
  end

  after(:all) { FileUtils.rm_rf('./db/') }

  describe 'search by ID' do
    context 'without an output folder' do
      before { Ruson.output_folder = nil }

      it 'should raise an ArgumentError' do
        expect {
          Vehicle.find(999)
        }.to raise_error(
          ArgumentError,
          'No output folder defined. You can define it using ' \
          'Ruson.output_folder = "/path/to/db/folder"'
        )
      end
    end

    context 'with an output folder' do
      before { Ruson.output_folder = './db/' }

      describe 'using find' do
        context "searching a record which doesn't exist" do
          it 'should raise a Ruson::RecordNotFound error' do
            expect {
              vehicle = Vehicle.find(999)
              expect(vehicle).to be_nil
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

            expected_vehicle = Vehicle.new(name: @vehicle1_name).to_hash
            expected_vehicle[:id] = 1 # Forces the ID

            expect(vehicle.to_hash).to eq(expected_vehicle)

            vehicle = Vehicle.find(2)

            expected_vehicle = Vehicle.new(name: @vehicle2_name).to_hash
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
            vehicle = Vehicle.find!(1)
            expect(vehicle.to_hash).to eq(@vehicle1.to_hash)

            vehicle = Vehicle.find!(2)
            expect(vehicle.to_hash).to eq(@vehicle2.to_hash)
          end
        end
      end
    end
  end

  describe 'search first record' do
    context 'without an output folder' do
      before { Ruson.output_folder = nil }

      it 'should raise an ArgumentError' do
        expect {
          Vehicle.first
        }.to raise_error(
          ArgumentError,
          'No output folder defined. You can define it using ' \
          'Ruson.output_folder = "/path/to/db/folder"'
        )
      end
    end

    context 'with an output folder' do
      before { Ruson.output_folder = './db/' }

      describe 'using first' do
        context 'without any records' do
          it 'should return nil' do
            expect(Tag.first).to be_nil
          end
        end

        context 'with at least one record' do
          it 'should return a record' do
            expect(Vehicle.first).to be_present
          end

          it 'should return the first record' do
            expect(Vehicle.first.to_hash).to eq(Vehicle.find(1).to_hash)
          end
        end
      end

      describe 'using first!' do
        context 'without any records' do
          it 'should raise a Ruson::RecordNotFound error' do
            expect {
              Tag.first!
            }.to raise_error(Ruson::RecordNotFound)
          end
        end

        context 'with at least one record' do
          it 'should return a record' do
            expect(Vehicle.first!).to be_present
          end

          it 'should return the first record' do
            expect(Vehicle.first!.to_hash).to eq(Vehicle.find(1).to_hash)
          end
        end
      end
    end
  end
end
