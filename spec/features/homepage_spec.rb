require 'rails_helper'

describe 'Home page' do
  let(:adderall_response) { File.read(File.expand_path('../../fixtures/adderall.json', __FILE__)) }

  before do
    stub_request(:get, /api.fda.gov\/drug\/label.json/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.1'}).
      to_return(body: adderall_response)
  end

  describe 'searching api' do
    it 'shows search results' do
      visit root_path

      fill_in 'Search', with: 'adderall'
      click_button 'search-button'

      expect(page).to have_content('Results found for "adderall"')
    end

    it 'requires search params' do
      visit root_path

      click_button 'search-button'

      expect(page.current_path).to eq(root_path)
      expect(page).to have_content('Please enter search criteria')
    end
  end
end
