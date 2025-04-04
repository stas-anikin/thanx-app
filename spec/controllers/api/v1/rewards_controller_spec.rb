require 'rails_helper'

RSpec.describe Api::V1::RewardsController, type: :controller do
  describe 'GET #index' do
    let!(:active_rewards) { create_list(:reward, 2) }
    let!(:inactive_rewards) { create_list(:reward, 2, is_active: false) }

    it 'returns only active rewards' do
      get :index
      expect(response).to have_http_status(:ok)

      rewards = JSON.parse(response.body)
      expect(rewards.size).to eq(2)
      expect(rewards.all? { |r| r['is_active'] }).to be_truthy
    end
  end

  describe 'GET #show' do
    let(:reward) { create(:reward) }

    it 'returns the reward' do
      get :show, params: { id: reward.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(reward.id)
    end

    it 'returns not found for non-existent reward' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end
end
