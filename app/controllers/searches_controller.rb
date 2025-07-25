class SearchesController < ApplicationController
  skip_before_action :verify_authenticity_token # Skip CSRF token verification for API requests

  SESSION_TIMEOUT = 5.minutes # Define the session timeout duration
  def create
    user_ip = request.remote_ip # Get the user's IP address
    query_text = params[:query] # Get the search query from the request parameters
    return head :ok if query_text.blank? # Do not process if the query is blank

    # Find the last "active" search for the same IP
    last_search = Search.where(user_ip: user_ip)
                        .where("last_seen_at > ?", SESSION_TIMEOUT.ago)
                        .order(last_seen_at: :desc)
                        .first

    if last_search && query_text.start_with?(last_search.query) # Check if the new query starts with the last query
      last_search.update!(query: query_text, last_seen_at: Time.current) # Update the last search with the new query and timestamp
    else
      Search.create(query: query_text, user_ip: user_ip, last_seen_at: Time.current) # Create a new search record
    end

    head :ok # Respond with a 200 OK status
  end
end
