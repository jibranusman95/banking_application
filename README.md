# Banking Application

## Overview

This is a simple banking application with merchant, admin and customer roles. The UI provides access to merchants and transactions for admins, a user's own transactions for merchants, and the same for customers. It provides a JWT authenticated API to charge and refund customers, customers must exist and there must be enough amount in the customer's balance.

## Rake Task

1. Add a rake task called "extract_from_csv".
   * When this task runs it should take a file path
    as an argument and create a merchant and admin users from CSV
    The rake task can be called like this: `rake 'users:extract_from_csv[./users.csv]'`

## API
1. JWT authentication is required to access the transaction endpoints, the endpoint `POST /auth/login` with parameters containing the merchant's login information. For example: `{ email: <merchant_email>, password: <merchant_paswword> }` which will return a token needed to authorize further transactions which should be added to the "Authorization" headers.

2. The transaction information is exposed in two endpoints, them being `POST /api/v1/transactions` and `POST /api/v1/transactions/refund` for charge and refund respectively.

3. The `POST /api/v1/transactions` requires the parameters `customer_email`, `customer_phone` and `amount`. A successful transaction returnsthe charge transaction ID.

4. The `POST /api/v1/transactions/refund` requires the parameter `transaction_id` which refers to the charge transaction ID that needs to be refunded.
