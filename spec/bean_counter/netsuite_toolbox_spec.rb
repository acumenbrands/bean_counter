require 'spec_helper'

describe BeanCounter::NetsuiteToolbox do

  let(:client_double) { double('client', get_saved_search: true) }

  before do
    Netsuite::Client.stub(:new).and_return(client_double)
  end

  describe 'search methods' do

    let(:name) { :this_is_a_test }
    let(:id)   { '123' }

    let(:start_id) { '74235' }

    let(:search_type) { BeanCounter::NetsuiteToolbox::SEARCH_RECORD_TYPE }

    let(:perform_search) do
      BeanCounter::NetsuiteToolbox.search(name, start_id)
    end

    context 'a given named search has an id' do

      let(:search_args) do
        [
          search_type, id, {
            start_id:               start_id,
            exit_after_first_batch: true,
            search_batch_size:      BeanCounter::NetsuiteToolbox::SEARCH_BATCH_SIZE
          }
        ]
      end

      before do
        BeanCounter::NetsuiteToolbox.add_search(name, id)
        perform_search
      end

      it 'invokes the saved search with the correct id' do
        expect(client_double).to have_received(:get_saved_search).with(*search_args)
      end

    end

    context 'a given named search does not have an id' do

      let(:expected_error) { BeanCounter::Errors::SearchIdDoesNotExist }

      before do
        BeanCounter::Config.netsuite_searches = {}
      end

      it 'should raise an error' do
        expect { perform_search }.to raise_error(expected_error)
      end

    end

    context 'the set of search ids is no longer a hash' do

      let(:expected_error) { BeanCounter::Errors::SearchIdSetNotAHash }

      before do
        BeanCounter::Config.netsuite_searches = 42
      end

      it 'should raise an error' do
        expect { perform_search }.to raise_error(expected_error)
      end

    end

  end

end
