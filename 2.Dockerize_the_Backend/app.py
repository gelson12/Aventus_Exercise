from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
import random
import string


app = Flask(__name__)
# Configuring my PostgreSQL database URI below
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://gelson:shadow@db/aventus_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Defining a simple model for demonstration
class RandomData(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.String(50), nullable=False)

# Initialising the database
@app.before_first_request
def create_tables():
    db.create_all()

@app.route('/', methods=['GET'])  # Route for the root URL
def index():
    return jsonify({'message': 'Welcome to the Aventus API!'})

@app.route('/populate', methods=['POST'])
def populate():
    random_string = ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(10))
    new_data = RandomData(data=random_string)
    db.session.add(new_data)
    db.session.commit()
    return jsonify({'message': 'Data added successfully', 'data': random_string}), 201

@app.route('/delete', methods=['DELETE'])
def delete():
    try:
        num_rows_deleted = db.session.query(RandomData).delete()
        db.session.commit()
        return jsonify({'message': f'{num_rows_deleted} rows deleted'}), 200
    except:
        db.session.rollback()
        return jsonify({'message': 'A problem occurred'}), 500

if __name__ == '__main__':
    app.run(debug=True)
