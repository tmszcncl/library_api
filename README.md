# Library API

This is a Rails-based Library API.

## Docker Development Environment

The application is fully containerized for development.

### Setup and Running the App

1.  **Build and Start the containers:**
    ```bash
    docker compose up --build
    ```
    This will build the image, install gems, and start both the Rails server and the PostgreSQL database. The app will be accessible at `http://localhost:3000`.

2.  **Run Migrations:**
    If you have new migrations, run them in the web container:
    ```bash
    docker compose run --rm web bin/rails db:migrate
    ```

3.  **Annotate Models:**
    Models are automatically annotated after migrations. To run it manually:
    ```bash
    docker compose run --rm web bin/rails g annotate_rb:install
    ```

### Running Tests

To run the full Minitest suite:

```bash
docker compose run --rm web bin/rails test
```

### Useful Commands

*   **Open a Rails console:**
    ```bash
    docker compose run --rm web bin/rails console
    ```
*   **Run a one-off command:**
    ```bash
    docker compose run --rm web [command]
    ```
*   **Stop the containers:**
    ```bash
    docker compose down
    ```

## Technology Stack

*   **Ruby:** 3.4.7
*   **Rails:** 8.1.2
*   **Database:** PostgreSQL 16
*   **Gems:** `annotaterb` for model documentation.
