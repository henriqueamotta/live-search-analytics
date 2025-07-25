class AnalyticsController < ApplicationController
  def index
    # Clears incomplete searches. Search is considered incomplete if it has not been updated in the last 10 seconds.
    cleanup_incomplete_searches

    # Groups searches by query and orders them by the count of occurrences.
    # Shows the 10 most popular searches.
    @trends = Search.group(:query)
                    .order("COUNT(id) DESC")
                    .limit(10)
                    .count
  end

  private

  def cleanup_incomplete_searches
    # Search all recent searches for the same IP
    recent_searches_by_ip = Search.where("created_at > ?", 1.hour.ago)
                                  .group_by(&:user_ip)

    searches_to_delete = [] # Array to hold searches to be deleted

    recent_searches_by_ip.each do |user_ip, searches|
      # Sort searches by newest to oldest
      sorted_searches = searches.sort_by(&:created_at).reverse

      next if sorted_searches.count < 2 # Skip if there are not enough searches
      final_search = sorted_searches.first

      sorted_searches[1..].each do |potencial_incomplete| # Check all but the most recent search
        if final_search.query.start_with?(potencial_incomplete.query) # If the most recent search starts with the previous one
        searches_to_delete << potencial_incomplete.id # Add to the list of searches to delete
        end
      end
    end
    Search.where(id: searches_to_delete).delete_all if searches_to_delete.any? # Delete all searches in the list
  end
end
