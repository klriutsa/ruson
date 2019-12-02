require 'spec_helper'

RSpec.describe 'Persistence' do
  RUSON_DB_PATH = './db/'.freeze

  after(:all) { FileUtils.rm_rf(RUSON_DB_PATH) }

  context 'without an output folder' do
    it 'should raise an ArgumentError' do
      expect {
        User.new({}).save
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
        user = User.new({})
        user.save
        expect(user.id).to be_present
      end

      context 'without any existing files for the current model' do
        it 'should assign the ID 1' do
          user = User.new({})
          user.save

          expect(user.id).to eq 1
        end
      end

      context 'with an existing JSON file for the current model, but with an ' \
              'invalid name' do
        before do
          # Generate an invalid file
          FileUtils.mkdir_p('./db/Users')
          File.open('./db/Users/test.json', 'w') { |file| file.write('{}') }
        end
        it 'should assign the ID 1' do
          user = User.new({})
          user.save

          expect(user.id).to eq 1
        end
      end

      context 'with an existing JSON file for the current model' do
        before { User.new({}).save }
        it 'should assign the ID 2' do
          user = User.new({})
          user.save

          expect(user.id).to eq 2
        end
      end

      context 'with an existing JSON file for the current model but its ' \
              'filename is ID 10' do
        before do
          FileUtils.mkdir_p('./db/Users')
          File.open('./db/Users/10.json', 'w') do |file|
            file.write(User.new({}.to_json))
          end
        end

        it 'should assign the ID 11' do
          user = User.new({})
          user.save

          expect(user.id).to eq 11
        end
      end
    end

    describe 'Model creation' do
      def model_path(user_id)
        File.join(Ruson.output_folder, 'Users', "#{user_id}.json")
      end

      context 'using new and save' do
        it 'should create a file with the id as filename' do
          user = User.new({})
          user.save

          expect(File).to exist(model_path(user.id))
        end

        it 'should have save all the attributes to the file' do
          user = User.new({})
          user.save

          expect(File.read(model_path(user.id))).to eq(user.to_json)
        end
      end

      context 'using create' do
        it 'should create a file with the id as filename' do
          user = User.create({})

          expect(File).to exist(model_path(user.id))
        end

        it 'should have save all the attributes to the file' do
          user = User.create({})

          expect(File.read(model_path(user.id))).to eq(user.to_json)
        end
      end
    end

    describe 'Model update' do
      context 'updating an attribute and calling save' do
        subject do
          user = User.new(name: 'zedtux')
          user.save
          user
        end

        it 'should update the model file' do
          subject.url = 'https://github.com/klriutsa/ruson'

          expect(subject.save).to be_truthy

          saved_data = File.read(
            File.join(Ruson.output_folder, 'Users', "#{subject.id}.json")
          )
          expect(saved_data).to eq(
            User.new(
              id: 1,
              name: 'zedtux',
              url: 'https://github.com/klriutsa/ruson'
            ).to_json
          )
        end
      end

      context 'using the update method' do
        subject { Vehicle.create(name: 'Jean Bart') }

        it 'should update all the given attributes' do
          now = Time.now
          expect(subject.update(expiredAt: now, price: 12)).to be_truthy

          saved_data = File.read(
            File.join(Ruson.output_folder, 'Vehicles', "#{subject.id}.json")
          )
          expect(saved_data).to eq(
            Vehicle.new(
              id: 1,
              name: 'Jean Bart',
              price: 12,
              expired_at: now
            ).to_json
          )
        end
      end
    end

    describe 'Model destroy' do
      subject do
        user = User.new(name: 'zedtux')
        user.save
        user
      end

      it 'should delete the file' do
        subject.destroy

        expect(File).to_not exist(
          File.join(Ruson.output_folder, 'Users', "#{subject.id}.json")
        )
      end
    end
  end
end
