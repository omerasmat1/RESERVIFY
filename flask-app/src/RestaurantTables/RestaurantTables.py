from flask import Blueprint, request, jsonify, make_response
import json
from src import db


restauranttables = Blueprint('restauranttables', __name__)

# RestaurantTables(referred to as tables in assignment 6)
@restauranttables.route('/restauranttables', methods=['GET', 'POST'])
def RestaurantTables_get():
    cursor = db.get_db().cursor()
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
@restauranttables.route('/restauranttables/<int:TableID>', methods=['GET', 'PUT', 'DELETE'])
def RestaurantTables_post(TableID):
    cursor = db.get_db().cursor()
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
