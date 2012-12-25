# encoding: UTF-8
require 'spec_helper'

describe CurrenciesController do
  render_views

  describe 'GET :index' do
    before do
      Rate.stub(:at_month).and_return([
        FactoryGirl.build_stubbed(:rate_sequence),
        FactoryGirl.build_stubbed(:rate_sequence),
        FactoryGirl.build_stubbed(:rate_sequence)
      ])
    end

    it 'should be successful' do
      get :index, format: :json

      response.should be_success
      response.content_type.should == Mime::JSON
      response.body.should eql('[{"code":"USD1","course":31.3},' +
        '{"code":"USD2","course":32.3},{"code":"USD3","course":33.3}]')
    end
  end

  describe 'GET :show' do
    before do
      Currency.stub_chain(:with_code, :first, :rates, :at_month, :first).
        and_return(FactoryGirl.build_stubbed(:rate))
    end

    it 'should be successful' do
      get :show, id: 'USD', format: :json

      response.should be_success
      response.content_type.should == Mime::JSON
      response.body.should eql('{"course":30.3}')
    end
  end

  describe 'GET :edit' do
    it 'should be failure' do
      expect{get :edit, format: :json}.
        to raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET :new' do
    it 'should be failure' do
      expect{get :new}.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'POST :create' do
    it 'should be failure' do
      expect{post :create, format: :json}.
        to raise_error(ActionController::RoutingError)
    end
  end

  describe 'POST :update' do
    it 'should be failure' do
      expect{post :update, format: :json}.
        to raise_error(ActionController::RoutingError)
    end
  end

  describe 'DELETE :destroy' do
    it 'should be failure' do
      expect{delete :destroy, format: :json}.
        to raise_error(ActionController::RoutingError)
    end
  end
end