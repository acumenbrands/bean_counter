require 'spec_helper'

describe BeanCounter::SearchManager do

  let(:search_name) { :test }
  let(:fake_result) { { id: '1234' } }

  let(:first_result_set)  { [fake_result]*BeanCounter::NetsuiteToolbox::SEARCH_BATCH_SIZE }
  let(:second_result_set) { [fake_result]*37 }

  let(:cache)   { BeanCounter::Cache }
  let(:toolbox) { BeanCounter::NetsuiteToolbox }

  let(:search) { BeanCounter::SearchManager.new(search_name) }

  before do
    cache.stub(:record_search_results)
  end

  describe 'a typical search' do

    before do
      toolbox.stub(:search).and_return(first_result_set, second_result_set)
      search.execute_and_cache!
    end

    it 'caches results for the first batch' do
      expect(cache).to have_received(:record_search_results).with(first_result_set)
    end

    it 'caches results for the second batch' do
      expect(cache).to have_received(:record_search_results).with(second_result_set)
    end

    it 'invokes caching twice' do
      expect(cache).to have_received(:record_search_results).twice
    end

  end

  describe 'a search that ends with an empty set' do

    before do
      toolbox.stub(:search).and_return(first_result_set, [])
      search.execute_and_cache!
    end

    it 'caches results for the first batch' do
      expect(cache).to have_received(:record_search_results).with(first_result_set)
    end

    it 'invokes caching once' do
      expect(cache).to have_received(:record_search_results).once
    end

  end

  describe 'a search that returns an empty set' do

    before do
      toolbox.stub(:search).and_return([])
      search.execute_and_cache!
    end

    it 'does not invoke caching' do
      expect(cache).to_not have_received(:record_search_results)
    end

  end

end
