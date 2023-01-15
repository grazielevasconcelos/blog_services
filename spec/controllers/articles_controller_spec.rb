# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlesController do
  describe 'GET #index' do
    subject(:index) { get :index }

    context 'when resource is found' do
      before { index }

      it 'returns a 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a 200 OK status' do
        expect(response.body).to eq('[]')
      end
    end
  end
end
