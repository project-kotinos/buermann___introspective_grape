require 'rails_helper'

describe Dummy::CompanyAPI, type: :request do
  before :all do
    Company.find_by_name("Sprockets") || Company.make!(name:"Sprockets")
  end

  let(:company) { Company.find_by_name("Sprockets") }

  it "should return a list of companies" do
    get '/api/v1/companies'
    response.should be_success
    json.length.should > 0
    json.map{|c| c['id'].to_i}.include?(company.id).should == true
  end

  it "should return the specified company" do
    get "/api/v1/companies/#{company.id}"
    response.should be_success
    json['name'].should == company.name
  end

  it "should return an error if the company doesn't exist" do
    get "/api/v1/companies/#{Company.last.id+1}"
    response.code.should == "404"
  end


  it "should create a company" do
    post "/api/v1/companies", { name: 'Test 123', short_name: 'T123' } 
    response.should be_success
    json['name'].should       == "Test 123"
    json['short_name'].should == "T123"
  end
  
  it "should validate a new company" do
    post "/api/v1/companies", { name: 'a'*257, short_name: 'a'*11 }
    response.code.should == "400"
    json['error'].should == "Name: is too long (maximum is 256 characters), Short Name: is too long (maximum is 10 characters)"
  end


  it "should update the company" do
    new_name = 'New Test 1234'
    put "/api/v1/companies/#{company.id}", { name: new_name } 
    response.should be_success
    company.reload
    company.name.should == new_name
    json['name'].should == new_name
  end

  it "should validate the company on update" do
    old_name = company.name
    put "/api/v1/companies/#{company.id}", { name: 'a'*257, short_name: 'a'*11 }
    response.code.should == "400"
    company.reload
    company.name.should == old_name
    json['error'].should == "Name: is too long (maximum is 256 characters), Short Name: is too long (maximum is 10 characters)"
  end

end