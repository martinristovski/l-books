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
  * RSpec (97% coverage): https://lbooks-4995.herokuapp.com/cov_rspec
  * Cucumber (85% coverage): https://lbooks-4995.herokuapp.com/cov_cucumber

## Running it locally

_Prerequisites: A PostgreSQL server._

After cloning the project, run `bundle install` to install dependencies.
Run `rails db:migrate` to run migrations on the database. Run `rails db:seed`
to seed test data.

Run `rails server` to run the development server.  To run the tests, 
use the `rspec` and `cucumber` commands. 

_(Note that some of these commands may be different on your end depending 
on how Ruby is installed on your computer.)_

## All implemented features

* Search by title/author, course, and ISBN.
* See book results, and see book information page.
* See listing info for a book, and see individual listings.
* Register and login using an account.
* Create, delete, and edit a listing, including adding/removing images. (Images are stored on an S3 server.)
* Automatically retrieve book information from Google Books (or provide such information manually if Google Books cannot find it).
* Rate a seller/transaction.
* User dashboard.
* E-mail verification for school-specific (in this case, Columbia-specific) e-mail addresses.
* E-mail and password-based authentication (implemented manually using [this tutorial](https://www.section.io/engineering-education/how-to-setup-user-authentication-from-scratch-with-rails-6/).
