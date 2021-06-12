This project is a first attempt to use rails for building applications. It aims to provide a simple API for building transactions between accounts. It contains the following entities:

- Account: for holding balances
- Transaction: to save history of interchange of money between accounts
- User: to hold a set of accounts

The gems devise and simple_token_authentication are used for login and authentication.

How to use:

- Donwload the code
- Create the dbs with rake db:create
- Run the migrations with rake db:migrate
- Run your rails server with rails s
- You can use devise endpoint POST /users/sign_in endpoint to create a new user. The body should look like:
    
    {
        "user": {
            "email" : "test@test.com",
            "password" : "password",
            "password_confirmation": "password"
        }
    }
    
- Or you can create a new user by accessing rails console via terminal.
- Then you can use your token in the database to do the other requests via Postman or related application by setting X-User-Email and X-User-Token your header.
- Once you're logged in, you can create accounts via POST /accounts passing a balance property in your input JSON. Default value is 0.0.
- You can also visualize your own accounts via GET /accounts
- You can transfer money to another account via POST /transactions with the following body:
    {
        "source_id" : 3,
        "destiny_id" : 1,
        "amount" : 7.53
    }
    
- Some restrictions apply to Transactions creation:
    - You cannot transfer money from one account to the same one
    - You cannot transfer more money than you actually have in your account 

Room for improvement:
- Changing the type of amount
- Creating a SuperAdmin account to centralize responsability for creating accounts and assigning them to the users
- Using a gem to account for different currencies when dealing with the transactions
- Increasing security by not saving the amount of an account in the db 
- Completing the API with endpoints for updating or deleting accounts and users
- Creating new tests to increase robustness

Final considerations:

I am very happy to have experienced playing a little bit with Rails and I hope to have the opportunity to continue improving my skills on this absolutely productive tool.
