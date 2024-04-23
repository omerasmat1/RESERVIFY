from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


products = Blueprint('RestaurantTables', __name__)

# RestaurantTables(referred to as tables in assignment 6)
@RestaurantTables.route('/RestaurantTables', methods=['GET', 'POST'])
def RestaurantTables():
    cursor = db.cursor(dictionary=True)
    if request.method == 'GET':
        cursor.execute("SELECT * FROM RestaurantTables")
        RestaurantTables = cursor.fetchall()
        return jsonify(RestaurantTables)
    elif request.method == 'POST':
        data = request.get_json()
        sql = "INSERT INTO tables (Seats, Location, RestaurantID) VALUES (%s, %s, %s)"
        values = (data['Seats'], data['Location'], data['RestaurantID'])
        cursor.execute(sql, values)
        db.commit()
        return jsonify({'message': 'RestaurantTable stored successfully'})
        
        
# RestaurantTables{TableID}(referred to as tables{id} in assignment 6 submission)
@RestaurantTables.route('/RestaurantTables/<int:TableID>', methods=['GET', 'PUT', 'DELETE'])
def RestaurantTables(TableID):
    cursor = db.cursor(dictionary=True)
    if request.method == 'GET':
        cursor.execute("SELECT * FROM RestaurantTables WHERE TableID = %s", (TableID,))
        RestaurantTables = cursor.fetchone()
        return jsonify(RestaurantTables)
    elif request.method == 'PUT':
        data = request.get_json()
        sql = "UPDATE RestaurantTables SET Seats = %s, Location = %s, RestaurantID = %s WHERE TableID = %s"
        values = (data['Seats'], data['Location'], data['RestaurantID'], TableID)
        cursor.execute(sql, values)
        db.commit()
        return jsonify({'message': 'RestaurantTable updated successfully'})
    elif request.method == 'DELETE':
        cursor.execute("DELETE FROM Customers WHERE TableID = %s", (TableID,))
        db.commit()
        return jsonify({'message': 'RestaurantTable deleted successfully'})
