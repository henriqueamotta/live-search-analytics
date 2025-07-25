require 'rails_helper'

RSpec.describe "Searches", type: :request do
  describe "POST /create" do
    let(:user_ip) { "127.0.0.1" }

    before do
      Search.delete_all
    end

    it "creates a new search record for new query" do
      expect {
        post "/searches", params: { query: "What is" }, headers: { "REMOTE_ADDR" => user_ip }
    }.to change(Search, :count).by(1)
    expect(response).to have_http_status(:ok)
    expect(Search.last.query).to eq("What is")
    end

    it "updates an existing record if the new query is a continuation" do
      search_record = Search.create!(query: "What is", user_ip: user_ip, last_seen_at: Time.current)
      expect {
        post "/searches", params: { query: "What is a good car" }, headers: { "REMOTE_ADDR" => user_ip }
      }.to_not change(Search, :count)
      expect(search_record.reload.query).to eq("What is a good car")
    end

    it "creates a new record for a different user (IP)" do
      post "/searches", params: { query: "1st (random) user searches" }, headers: { "REMOTE_ADDR" => user_ip }
      expect {
        post "/searches", params: { query: "2nd (random) user searches" }, headers: { "REMOTE_ADDR" => user_ip }
    }.to change(Search, :count).by(1)
      expect(Search.last.query).to eq("2nd (random) user searches")
    end

    it "creates a new record for a different query" do
      post "/searches", params: { query: "1st user search" }, headers: { "REMOTE_ADDR" => user_ip }
      expect {
        post "/searches", params: { query: "2nd user search" }, headers: { "REMOTE_ADDR" => "192.168.1.1" }
    }.to change(Search, :count).by(1)
    end
  end
end
