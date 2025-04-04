# Rewards Redemption API

A RESTful API for a rewards redemption system built with Ruby on Rails. This system allows users to manage points, browse available rewards, and redeem points for rewards.

## Features

- User management with points balance tracking
- Rewards catalog with active/inactive status
- Redemption workflow with status tracking
- Point deduction and refund logic

## Technology Stack

- Ruby 3.2.2
- Rails 8.0.2
- PostgreSQL
- RSpec for testing
- Active Model Serializers for JSON responses

## Setup Instructions

### Prerequisites

- Ruby 3.2.2 or higher
- PostgreSQL 13 or higher
- Bundler

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/thanx_rewards_app.git
   cd thanx_rewards_app
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Database setup:
   ```bash
   # Create and migrate the database
   rails db:create db:migrate
   
   # Seed the database with sample data
   rails db:seed
   ```

4. Start the server:
   ```bash
   rails server
   ```

The API will be available at `http://localhost:3000`.

## Testing

### Running the test suite

Run the RSpec test suite:
```bash
rspec
```

This will execute all model, controller, and request specs.

### Manual API testing

You can use the included API testing script:
```bash
bin/api_tester
```

This script makes requests to all endpoints and displays the responses.

## API Endpoints

### Users

```
# Get all users
GET /api/v1/users

# Get a specific user
GET /api/v1/users/:id

# Create a user
POST /api/v1/users
{
  "user": {
    "email": "user@example.com"
  }
}

# Get a user's points balance
GET /api/v1/users/:id/points_balance

# Get a user's redemptions
GET /api/v1/users/:id/redemptions

# Add points to a user
PATCH /api/v1/users/:id/add_points
{
  "amount": 100
}
```

### Rewards

```
# Get all active rewards
GET /api/v1/rewards

# Get a specific reward
GET /api/v1/rewards/:id
```

### Redemptions

```
# Create a redemption
POST /api/v1/redemptions
{
  "redemption": {
    "user_id": 1,
    "reward_id": 1
  }
}

# Get a specific redemption
GET /api/v1/redemptions/:id

# Cancel a redemption
PATCH /api/v1/redemptions/:id/cancel
```

## Example cURL Commands

### Creating a User

```bash
curl -X POST http://localhost:3000/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "test@example.com"}}'
```

### Getting User's Points Balance

```bash
curl http://localhost:3000/api/v1/users/1/points_balance
```

### Adding Points to a User

```bash
curl -X PATCH http://localhost:3000/api/v1/users/1/add_points \
  -H "Content-Type: application/json" \
  -d '{"amount": 100}'
```

### Creating a Redemption

```bash
curl -X POST http://localhost:3000/api/v1/redemptions \
  -H "Content-Type: application/json" \
  -d '{"redemption": {"user_id": 1, "reward_id": 1}}'
```

### Cancelling a Redemption

```bash
curl -X PATCH http://localhost:3000/api/v1/redemptions/1/cancel
```

## Business Logic

1. Users start with 0 points and can have points added
2. Points cannot be negative
3. Users can only redeem rewards if they have sufficient points
4. Points are deducted immediately upon redemption
5. If a redemption is cancelled, points are refunded
6. Only pending redemptions can be cancelled
7. Only active rewards can be redeemed

### Project Structure

- `app/models` - Business logic and relationships
- `app/controllers/api/v1` - API endpoints
- `app/serializers` - JSON response formatting
- `spec` - Tests
