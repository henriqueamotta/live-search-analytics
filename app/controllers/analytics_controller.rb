# app/controllers/analytics_controller.rb
class AnalyticsController < ApplicationController
  def index
    cleanup_incomplete_searches
    @trends = fetch_trends
  end

  def trends
    cleanup_incomplete_searches
    @trends = fetch_trends
    render json: @trends
  end

  private

  def fetch_trends
    Search.group(:query).order("COUNT(id) DESC").limit(50).count
  end

  def cleanup_incomplete_searches
    ips_to_check = Search.where("last_seen_at > ?", 1.hour.ago).pluck(:user_ip).uniq

    ips_to_check.each do |ip|
      searches = Search.where(user_ip: ip)
      next if searches.count < 2

      final_search = searches.order(last_seen_at: :desc).first
      next unless final_search

      searches_to_delete = searches.where.not(id: final_search.id).select do |s|
        final_search.query.start_with?(s.query) && final_search.query != s.query
      end

      Search.where(id: searches_to_delete.map(&:id)).delete_all if searches_to_delete.any?
    end
  end
end
