require 'rails_helper'

describe EventPolicy do
  subject { described_class }

  let(:user) { FactoryBot.create(:user) }

  let(:event_wo_pincode) { FactoryBot.create(:event, user: user) }
  let(:event_w_pincode) { FactoryBot.create(:event, user: user, pincode: '777') }

  let(:correct_cookies) { { "events_#{event_w_pincode.id}_pincode" => '777' } }

  describe 'event owner' do
    let(:event_owner) { UserContext.new(user, {}) }

    permissions :edit?, :update?, :destroy? do
      it { is_expected.to permit(event_owner, event_wo_pincode) }
    end
    permissions :show? do
      it { is_expected.to permit(event_owner, event_w_pincode) }
    end
  end

  describe 'another user' do
    let(:another_user) { FactoryBot.create(:user) }
    let(:another_user_wo_pincode) { UserContext.new(another_user, {}) }
    let(:another_user_w_pincode) { UserContext.new(another_user, correct_cookies) }

    permissions :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(another_user_wo_pincode, event_wo_pincode) }
    end
    permissions :show? do
      it { is_expected.not_to permit(another_user_wo_pincode, event_w_pincode) }
    end
    permissions :show? do
      it { is_expected.to permit(another_user_w_pincode, event_w_pincode) }
    end
  end

  describe 'anonymous' do
    let(:anon_w_pincode) { UserContext.new(nil, correct_cookies) }

    permissions :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(anon_w_pincode, event_wo_pincode) }
    end
    permissions :show? do
      it { is_expected.to permit(anon_w_pincode, event_w_pincode) }
    end
  end
end
