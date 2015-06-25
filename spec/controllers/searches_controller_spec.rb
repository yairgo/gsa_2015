require 'rails_helper'

describe SearchesController do
  describe '#show' do
    let(:search_query) { 'some query' }
    let(:page) { '1' }
    let(:search_params) { { search: { generic_name: search_query }, page: page } }
    let(:search) { double 'search' }

    it 'gets search results' do
      expect(Search).to receive(:search_generic_name).with(search_query, page) { search }
      get :show, search_params
      expect(assigns(:search)).to eq(search)
    end

    context 'no query given' do
      it 'redirects to home page and shows flash alert' do
        get :show, {}
        expect(page).to redirect_to(root_path)
      end
    end
  end
end
