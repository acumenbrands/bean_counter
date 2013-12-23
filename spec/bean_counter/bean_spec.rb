require 'spec_helper'

describe BeanCounter::Bean do

  let(:sku)   { 'THIS-IS-A-SKU' }
  let(:upc)   { '356852254677' }
  let(:value) { 'a positive integer value' }
  let(:names) { [:sku_with_vendor, :upc_code] }

  let(:target) { double(true, sku_with_vendor: sku, upc_code: upc) }

  let(:bean)   { BeanCounter::Bean.new(target) }

  before do
    bean.stub(:update_from_cache)
    bean.stub(:identifier_names).and_return(names)
  end

  describe 'an item with cached data' do

    before do
      BeanCounter::Cache.send(:namespace).set(sku, value)
      BeanCounter::Cache.send(:namespace).set(upc, value)
      bean.count!
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

end
