require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    let!(:users) { create_list(:user, 3) }

    it 'returns all users' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }

    it 'returns the user' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(user.id)
    end

    it 'returns not found for non-existent user' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { user: { email: 'test@example.com' } } }
    let(:invalid_params) { { user: { email: '' } } }

    it 'creates a new user with valid params' do
      expect {
        post :create, params: valid_params
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns errors with invalid params' do
      expect {
        post :create, params: invalid_params
      }.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #points_balance' do
    let(:user) { create(:user, points_balance: 500) }

    it 'returns the user points balance' do
      get :points_balance, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['points_balance']).to eq(500)
    end
  end

  describe 'GET #redemptions' do
    let(:user) { create(:user, :with_points) }
    let!(:redemptions) { create_list(:redemption, 2, user: user) }

    it 'returns user redemptions' do
      get :redemptions, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'PATCH #add_points' do
    let(:user) { create(:user, points_balance: 100) }

    it 'adds points to user balance' do
      patch :add_points, params: { id: user.id, amount: 50 }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['points_balance']).to eq(150)
      expect(user.reload.points_balance).to eq(150)
    end
  end
end
