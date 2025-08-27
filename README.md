# Live Search Analytics Application

## Description

This is a Full-Stack application built with Ruby on Rails and Vanilla JavaScript. The project's goal is to create a search box that analyzes user search queries in real-time, logging each entry and displaying live analytics on the most popular terms.

The main focus is on the engineering behind collecting and analyzing the search data. This includes solving challenges like the "pyramid problem" (consolidating partial queries) and normalizing data to generate accurate trend analyses.

## Core Features

-   **Real-time Search Logging:** Every search is logged and processed in real-time. A `debounce` technique on the front-end optimizes performance by preventing server overload.
-   **"Pyramid Problem" Solution:** The back-end consolidates partial searches (e.g., "how", "how to install") into a single final query ("how to install ruby"), preventing the pollution of analytics data.
-   **Repeated Search Counting:** The logic differentiates between a continuous search and a repeated search, ensuring that if a user searches for the same term multiple times, the popularity count increases correctly.
-   **Data Normalization:** Search queries are normalized to be insensitive to case, accents, and punctuation, ensuring that "Rails," "rails," and "rails?" are grouped as the same trend.
-   **Trend Analysis in Percentages:** The interface displays the popularity of each term as a percentage of the total, featuring a visual bar for easier data comprehension.
-   **Dynamic UI Updates:** The trends table is updated in real-time without requiring a page reload, using the JavaScript Fetch API to communicate with a back-end JSON API.

## Tech Stack

-   **Back-End:** Ruby on Rails
-   **Front-End:** JavaScript (Vanilla JS), HTML5, CSS3
-   **Database:** PostgreSQL
-   **Testing:** RSpec

## Local Environment Setup

To run the project on your local machine, follow the steps below:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/henriqueamotta/live-search-analytics.git](https://github.com/henriqueamotta/live-search-analytics.git)
    cd live-search-analytics
    ```

2.  **Install dependencies:**
    ```bash
    bundle install
    ```

3.  **Set up the database:**
    ```bash
    rails db:create
    rails db:migrate
    ```

4.  **Start the Rails server:**
    ```bash
    rails s
    ```

5.  Open your browser and navigate to `http://localhost:3000`.

## Running Tests

To run the automated test suite, which validates the back-end logic, execute the following command:
```bash
bundle exec rspec
```

## Architectural and Logic Decisions

The most challenging part of the project was the logic for collecting and processing the search queries.

### 1. Solving the "Pyramid Problem" and Search Counting
To prevent the pyramid problem while correctly counting repeated searches, the logic in the `SearchesController` uses a compound condition that updates a record if the search is a continuation but creates a new record if the search is identical (a repetition) or entirely new.

### 2. Search Query Normalization
To ensure the accuracy of the trends, every search query is normalized in the `SearchesController` before being saved, using a chain of methods like `I18n.transliterate` (to remove accents), `.downcase`, and `.gsub` (to remove punctuation).

### 3. Dynamic Updates with a JSON API
To update the interface without reloading the page, a dedicated JSON API was created at the `GET /analytics/trends` route. This route is consumed by the application's JavaScript, which uses the `Fetch API` to get the popularity data (already calculated as percentages) and then dynamically rebuilds the trends table in the DOM.

## Author

**Henrique Motta**
- https://www.linkedin.com/in/henriqueamotta/
- https://github.com/henriqueamotta
- henriqueamotta@gmail.com
