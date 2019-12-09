require 'spec_helper'

RSpec.describe 'Persistence' do
  RUSON_DB_PATH = './db/'.freeze

  after(:all) { FileUtils.rm_rf(RUSON_DB_PATH) }

  context 'without an output folder' do
    it 'should raise an ArgumentError' do
      expect {
        Vehicle.new({}).save
      }.to raise_error(
        ArgumentError,
        'No output folder defined. You can define it using ' \
        'Ruson.output_folder = "/path/to/db/folder"'
      )
    end
  end

  context 'with an output folder' do
    before do
      Ruson.output_folder = RUSON_DB_PATH
      FileUtils.rm_rf(Ruson.output_folder)
    end

    describe 'Unique ID generation' do
      it 'should generate a uniq ID' do
        vehicle = Vehicle.new({})
        vehicle.save
        expect(vehicle.id).to be_present
      end

      context 'without any existing files for the current model' do
        it 'should assign the ID 1' do
          vehicle = Vehicle.new({})
          vehicle.save

          expect(vehicle.id).to eq 1
        end
      end

      context 'with an existing JSON file for the current model, but with an ' \
              'invalid name' do
        before do
          # Generate an invalid file
          FileUtils.mkdir_p('./db/Vehicles')
          File.open('./db/Vehicles/test.json', 'w') { |file| file.write('{}') }
        end
        it 'should assign the ID 1' do
          vehicle = Vehicle.new({})
          vehicle.save

          expect(vehicle.id).to eq 1
        end
      end

      context 'with an existing JSON file for the current model' do
        before { Vehicle.new({}).save }
        it 'should assign the ID 2' do
          vehicle = Vehicle.new({})
          vehicle.save

          expect(vehicle.id).to eq 2
        end
      end

      context 'with an existing JSON file for the current model but its ' \
              'filename is ID 10' do
        before do
          FileUtils.mkdir_p('./db/Vehicles')
          File.open('./db/Vehicles/10.json', 'w') do |file|
            file.write(Vehicle.new({}.to_json))
          end
        end

        it 'should assign the ID 11' do
          vehicle = Vehicle.new({})
          vehicle.save

          expect(vehicle.id).to eq 11
        end
      end
    end

    describe 'Model creation' do
      def model_path(user_id)
        File.join(Ruson.output_folder, 'Vehicles', "#{user_id}.json")
      end

      context 'using new and save' do
        it 'should create a file with the id as filename' do
          vehicle = Vehicle.new({})
          vehicle.save

          expect(File).to exist(model_path(vehicle.id))
        end

        it 'should have save all the attributes to the file' do
          vehicle = Vehicle.new({})
          vehicle.save

          expect(File.read(model_path(vehicle.id))).to eq(
            '{"name":null,"price":0.0,"expiredAt":null}'
          )
        end
      end

      context 'using create' do
        it 'should create a file with the id as filename' do
          vehicle = Vehicle.create({})

          expect(File).to exist(model_path(vehicle.id))
        end

        it 'should have save all the attributes to the file' do
          vehicle = Vehicle.create({})

          expect(File.read(model_path(vehicle.id))).to eq(
            '{"name":null,"price":0.0,"expiredAt":null}'
          )
        end
      end
    end

    describe 'Model update' do
      context 'updating an attribute and calling save' do
        subject do
          vehicle = Vehicle.new(name: 'zedtux')
          vehicle.save
          vehicle
        end

        it 'should update the model file' do
          subject.price = 1.20

          expect(subject.save).to be_truthy

          saved_data = File.read(
            File.join(Ruson.output_folder, 'Vehicles', "#{subject.id}.json")
          )
          expect(saved_data).to eq(
            '{"name":"zedtux","price":1.2,"expiredAt":null}'
          )
        end
      end

      context 'using the update method' do
        subject { Vehicle.create(name: 'Jean Bart') }

        before do
          ENV['TZ'] = 'UTC'
        end

        it 'should update all the given attributes' do
          Timecop.freeze(Time.local(2019, 12, 7, 5, 6, 57)) do
            expect(subject.update(expiredAt: Time.now, price: 12)).to be_truthy

            saved_data = File.read(
              File.join(Ruson.output_folder, 'Vehicles', "#{subject.id}.json")
            )
            expect(saved_data).to eq(
              <<~JSON.gsub(/\n|\s{2}/, '')
                {
                  "name":"Jean Bart",
                  "price":12.0,
                  "expiredAt":"2019-12-07T05:06:57.000+00:00"
                }
              JSON
            )
          end
        end
      end
    end

    describe 'Model destroy' do
      subject do
        vehicle = Vehicle.new(name: 'zedtux')
        vehicle.save
        vehicle
      end

      it 'should delete the file' do
        subject.destroy

        expect(File).to_not exist(
          File.join(Ruson.output_folder, 'Vehicles', "#{subject.id}.json")
        )
      end
    end
  end
end
