# encoding: UTF-8
require 'spec_helper'

describe CurrenciesController do
  render_views

  describe 'GET :index' do
    before do
      Rate.stub(:at_month).and_return([
        FactoryGirl.build_stubbed(:rate),
        FactoryGirl.build_stubbed(:rate),
        FactoryGirl.build_stubbed(:rate)
      ])
    end

    it 'should be successful' do
      get :index, format: :json

      response.should be_success
      response.content_type.should == Mime::JSON
      response.body.should == '[{"code":"USD1","course":30.3},{"code":"USD2","course":30.3},{"code":"USD3","course":30.3}]'
    end
  end

  describe 'GET :show' do
    before do
      Currency.stub_chain(:with_code, :first, :rates, :at_month, :first).
        and_return(FactoryGirl.build_stubbed(:rate))
    end

    it 'should be successful' do
      get :show, id: "USD", format: :json

      response.should be_success
      response.content_type.should == Mime::JSON
      response.body.should == '{"course":30.3}'
    end
  end
end