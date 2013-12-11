require 'spec_helper'

describe BeanCounter::Config do

  let(:config) { BeanCounter::Config }

  describe 'standard configuration' do

    let(:account_id) { '123456' }

    before do
      BeanCounter.configure do |settings|
        settings.netsuite_account_id = account_id
      end
    end

    it 'correctly applies the value to the desired setting' do
      expect(config.netsuite_account_id).to eq(account_id)
    end

  end

  describe 'access attempt to undefined setting' do

    let(:expected_error) { BeanCounter::Errors::SettingNotConfigured }

    before do
      BeanCounter::Config.netsuite_account_id = nil
    end

    it 'raises a SettingNotConfigured error' do
      expect { config.netsuite_account_id }.to raise_error(expected_error)
    end

  end

end
