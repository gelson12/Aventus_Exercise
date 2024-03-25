# 1. Setup Your Project

* mkdir flask_postgres_demo
* cd flask_postgres_demo
* python3 -m venv venv
* source venv/bin/activate

# 2. Install Required Packages
(Installed Flask, SQLAlchemy, and the PostgreSQL driver (psycopg2) by running the following)

* pip install Flask SQLAlchemy psycopg2-binary
* pip install Flask==2.2.5
* pip install Werkzeug --upgrade
* pip check

# 2.1 setup database

* sudo -u postgres psql
* CREATE DATABASE aventus_db;
* CREATE USER gelson WITH ENCRYPTED PASSWORD 'shadow';
* GRANT ALL PRIVILEGES ON DATABASE mydatabase TO gelson;

(verify if database was successfully created)
* \list    

(view existing users)
* SELECT * FROM pg_catalog.pg_user;

(Configuring PostgreSQL to Start Automatically in my WSL)
* echo "sudo service postgresql start" >> ~/.bashrc

Reminder: to make sure my application's configuration uses localhost or 127.0.0.1 for the host, and specifies the correct database name, user, and password.)

# 3. Defining the Flask Application
created file name called "app.py"

# 4. Running the Flask Application
* export FLASK_APP=app.py 
* flask run

 # 4.1. Testing Endpoints
 
I'll populate the database with random data:
* curl -X POST http://localhost:5000/populate

OUTCOME RESULT:
{"data":"Qt69DssuZp","message":"Data added successfully"}


Then I'll test delete endpoint to see if all data from the database:
* curl -X DELETE http://localhost:5000/delete

OUTCOME RESULT:
{"message":"1 rows deleted"}

Next Steps/Things to improve on
Adjust the RandomData model to fit a more meaningful actual data structure.
Add better error handling and validations as needed.
Secure my endpoints if necessary, with authentication.
Consider organizing my project with Blueprints for larger applications.
should leverage environment variables to provide a secure way to access sensitive information,but since i haven't containerazed the app and still working on my local machine then its not a priority YET.
