require 'spec_helper'

describe BeanCounter::Bean do

  let(:sku)   { 'THIS-IS-A-SKU' }
  let(:upc)   { '356852254677' }
  let(:value) { 'a positive integer value' }
  let(:names) { [:sku_with_vendor, :upc_code] }

  let(:vendor_field)    { :custitem22 }
  let(:warehouse_field) { :quantityavailable }

  let(:item) do
    {
      columns: {
        :displayname    => sku,
        :upccode        => upc,
        warehouse_field => value,
        vendor_field    => value
      }
    }
  end

  let(:expected_hash) { JSON.parse(BeanCounter::Cache.quantity_json(item)) }

  let(:target) { double('target', sku_with_vendor: sku, upc_code: upc) }

  let(:bean)   { BeanCounter::Bean.new(target) }

  before do
    BeanCounter::Config.stub(:netsuite_vendor_quantity_field).and_return(vendor_field)
    BeanCounter::Config.stub(:netsuite_warehouse_quantity_field).and_return(warehouse_field)
    bean.stub(:update_from_cache).and_return(true)
    bean.stub(:identifier_names).and_return(names)
  end

  describe 'an item with cached data' do

    before do
      BeanCounter::Cache.write_to_cache(item)
      bean.count!
    end

    it 'collects the correct value' do
      expect(bean.cached_data).to eq(expected_hash)
    end

    it 'invokes update_from_cache' do
      expect(bean).to have_received(:update_from_cache)
    end

    it 'removes the cached data under the sku' do
      expect(BeanCounter::Cache.get(sku)).to be_nil
    end

    it 'removes the cached data under the sku' do
      expect(BeanCounter::Cache.get(upc)).to be_nil
    end

  end

  describe 'an item without cached data' do

    before do
      BeanCounter::Cache.delete(sku)
      BeanCounter::Cache.delete(upc)
      bean.stub(:remove_from_cache)
      bean.count!
    end

    it 'does not invoke update_from_cache' do
      expect(bean).to_not have_received(:update_from_cache)
    end

    it 'does not remove the cached data' do
      expect(bean).to_not have_received(:remove_from_cache)
    end

  end

  describe 'an item for which update_from_cache fails' do

    before do
      BeanCounter::Cache.write_to_cache(item)
      bean.stub(:update_from_cache).and_return(false)
      bean.stub(:remove_from_cache)
      bean.count!
    end

    it 'does not remove the cached data' do
      expect(bean).to_not have_received(:remove_from_cache)
    end

  end

end
