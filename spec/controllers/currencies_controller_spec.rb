# encoding: UTF-8
require 'spec_helper'

describe CurrenciesController do
  describe 'GET :index' do
    before do
      Rate.any_instance.stub(:at_month).and_return('[{"code":"USD", "course":30.97}]')
    end

    it 'should be successful' do
      get :index

      response.should be_success
      response.content_type.should == Mime::JSON
      response.body.should =~ '[{"code":"USD", "course":30.967}]'
    end
  end
end