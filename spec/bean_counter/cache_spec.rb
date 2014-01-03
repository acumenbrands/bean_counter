require 'spec_helper'

describe BeanCounter::Cache do

  describe 'caching a search' do

    let(:item_one_sku)                { 'ITEM-ONE-SKU' }
    let(:item_one_upc)                { '123456789012' }
    let(:item_one_vendor_quantity)    { '7' }
    let(:item_one_warehouse_quantity) { '33' }

    let(:item_two_sku)                { 'ITEM-TWO-SKU' }
    let(:item_two_upc)                { '210987654321' }
    let(:item_two_vendor_quantity)    { '204' }
    let(:item_two_warehouse_quantity) { '1' }

    let(:item_one) do
      {
        columns: {
          displayname:       item_one_sku,
          upccode:           item_one_upc,
          custitem22:        item_one_vendor_quantity,
          quantityavailable: item_one_warehouse_quantity
        }
      }
    end

    let(:item_two) do
      {
        columns: {
          displayname:       item_two_sku,
          upccode:           item_two_upc,
          custitem22:        item_two_vendor_quantity,
          quantityavailable: item_two_warehouse_quantity
        }
      }
    end

    let(:search_results) { [item_one, item_two] }

    before do
      Netsuite::Client.any_instance.stub(:get_saved_search).and_return(search_results)
      BeanCounter::Cache.record_search_results(search_results)
    end

    describe 'item one' do

      let(:get_by_sku) { BeanCounter::Cache.get(item_one_sku) }
      let(:get_by_upc) { BeanCounter::Cache.get(item_one_upc) }

      it 'has cached the correct vendor quantity for the sku' do
        expect(get_by_sku['vendor']).to eq(item_one_vendor_quantity.to_i)
      end

      it 'has cached the correct vendor quantity for the upc' do
        expect(get_by_upc['vendor']).to eq(item_one_vendor_quantity.to_i)
      end

      it 'has cached the correct warehouse quantity for the sku' do
        expect(get_by_sku['warehouse']).to eq(item_one_warehouse_quantity.to_i)
      end

      it 'has cached the correct warehouse quantity for the upc' do
        expect(get_by_upc['warehouse']).to eq(item_one_warehouse_quantity.to_i)
      end

    end

    describe 'item two' do

      let(:get_by_sku) { BeanCounter::Cache.get(item_two_sku) }
      let(:get_by_upc) { BeanCounter::Cache.get(item_two_upc) }

      it 'has cached the correct vendor quantity for the sku' do
        expect(get_by_sku['vendor']).to eq(item_two_vendor_quantity.to_i)
      end

      it 'has cached the correct vendor quantity for the upc' do
        expect(get_by_upc['vendor']).to eq(item_two_vendor_quantity.to_i)
      end

      it 'has cached the correct warehouse quantity for the sku' do
        expect(get_by_sku['warehouse']).to eq(item_two_warehouse_quantity.to_i)
      end

      it 'has cached the correct warehouse quantity for the upc' do
        expect(get_by_upc['warehouse']).to eq(item_two_warehouse_quantity.to_i)
      end

    end

  end

  describe '.quantity_json' do

    let(:item_sku)                { 'ITEM-TWO-SKU' }
    let(:item_vendor_quantity)    { nil }
    let(:item_warehouse_quantity) { nil }

    let(:item) do
      {
        columns: {
          displayname:       item_sku,
          custitem22:        item_vendor_quantity,
          quantityavailable: item_warehouse_quantity
        }
      }
    end

    let(:vendor_quantity)    { BeanCounter::Cache.get(item_sku)['vendor'] }
    let(:warehouse_quantity) { BeanCounter::Cache.get(item_sku)['warehouse'] }

    before do
      BeanCounter::Cache.write_to_cache(item)
    end

    it 'converts a nil value for vendor to zero' do
      expect(vendor_quantity).to eq(0)
    end

    it 'converts a nil value for warehouse to zero' do
      expect(warehouse_quantity).to eq(0)
    end

  end

  describe '.get' do

    let(:identifier) { 'ZOGM-A-SKU' }

    before do
      BeanCounter::Cache.delete(identifier)
    end

    it 'returns nil when no data is cached for a given identifier' do
      expect(BeanCounter::Cache.get(identifier)).to be_nil
    end

  end

end
