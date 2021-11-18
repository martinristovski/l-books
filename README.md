# L'Books

A SaaS product created for [COMS W4995: Engineering Software-as-a-Service](http://www.cs.columbia.edu/~junfeng/21fa-w4995/) in Fall 2021.

**Team members:**
- Martin Ristovski (mr3986)
- Ivy Cao (ic2502)
- Aditya Vikram Satnalika (avs2170)
- Vishnu Nair (vn2287)

**Important links:**
* GitHub: https://github.com/martinristovski/l-books
* Heroku: https://lbooks-4995.herokuapp.com/
* Coverage:
  * RSpec: https://lbooks-4995.herokuapp.com/cov_rspec
  * Cucumber: https://lbooks-4995.herokuapp.com/cov_cucumber

## Running it locally

_Prerequisites: A PostgreSQL server._

After cloning the project, run `bundle install` to install dependencies.
Run `rails db:migrate` to run migrations on the database. Run `rails db:seed`
to seed test data.

Run `rails server` to run the development server.  To run the tests, 
use the `rspec` and `cucumber` commands. 

_(Note that some of these commands may be different on your end depending 
on how Ruby is installed on your computer.)_

## Currently-implemented features

* Search by title/author, course, and isbn.
* See book results.
* See listings for a book.
* See listing page. (need to manually put in the URL; for example, `/listing/1`)

### Features implemented in iteration 2

1. User login, registration, and session creation (implemented manually using [this tutorial]([https://www.section.io/engineering-education/how-to-setup-user-authentication-from-scratch-with-rails-6/](https://www.section.io/engineering-education/how-to-setup-user-authentication-from-scratch-with-rails-6/))).
2. The ability to create a new listing, edit a listing, and delete that listing.
3. The ability to add a new book if the ISBN given for a book does not yet exist in our database.
4. New views and new/improved CSS styling.
5. New Cucumber and RSpec testing cases and scenarios

We also set up an S3 server to store images (although S3-specific features 
were not implemented in this iteration).

### Projected tasks for next iteration

- User dashboard and password edits/resets.
- Buyer-seller contact functionality.
- E-mail verification for school-specific e-mail addresses.
- Seller/transaction ratings.
- Associating books with specific courses and improving search filtering.