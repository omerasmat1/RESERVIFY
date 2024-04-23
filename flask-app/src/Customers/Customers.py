from flask import Blueprint, request, jsonify, make_response
import json
from src import db


customers = Blueprint('customers', __name__)

# Customers
@customers.route('/customers', methods=['GET', 'POST'])
def customers_get():
    cursor = db.get_db().cursor()
    # cursor = db.cursor(dictionary=True)
    if request.method == 'GET':
        cursor.execute("SELECT * FROM Customers")
        customers = cursor.fetchall()
        return jsonify(customers)
    elif request.method == 'POST':
        data = request.get_json()
        sql = "INSERT INTO Customers (FirstName, LastName, PhoneNumber, Email) VALUES (%s, %s, %s, %s)"
        values = (data['FirstName'], data['LastName'], data['PhoneNumber'], data['Email'])
        cursor.execute(sql, values)
        db.commit()
        return jsonify({'message': 'Customer created successfully'})

# Customers/{CustomerID}(MIGHT NOT WORK FIGURE THIS ONE OUT)
@customers.route('/customers/<int:customerID>', methods=['GET', 'PUT', 'DELETE'])
def customers_post(customerID):
    cursor = db.get_db().cursor()
    # cursor = db.cursor(dictionary=True)
    if request.method == 'GET':
        cursor.execute("SELECT * FROM Customers WHERE CustomerID = %s", (customerID,))
        customers = cursor.fetchone()
        return jsonify(customers)
    elif request.method == 'PUT':
        data = request.get_json()
        sql = "UPDATE Customers SET FirstName = %s, LastName = %s, PhoneNumber = %s, Email = %s WHERE CustomerID = %s"
        values = (data['FirstName'], data['LastName'], data['PhoneNumber'], data['Email'], CustomerID)
        cursor.execute(sql, values)
        db.commit()
        return jsonify({'message': 'Customer updated successfully'})
    elif request.method == 'DELETE':
        cursor.execute("DELETE FROM Customers WHERE CustomerID = %s", (customerID,))
        db.commit()
        return jsonify({'message': 'Customer deleted successfully'})
