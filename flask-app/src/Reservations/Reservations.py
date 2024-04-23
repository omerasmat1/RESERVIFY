from flask import Blueprint, request, jsonify, make_response
import json
from src import db


reservations = Blueprint('reservations', __name__)

#Reservations
@reservations.route('/reservations', methods=['GET', 'POST'])
def Reservations_get():
    cursor = db.get_db().cursor()
    if request.method == 'GET':
        cursor.execute("SELECT * FROM Reservations")
        reservations_data = cursor.fetchall()  # Changed variable name
        return jsonify(reservations_data)  # Return fetched data
    elif request.method == 'POST':
        data = request.get_json()
        sql = ("INSERT INTO Reservations (CustomerID, TableID, RestaurantID, ReservationTime, Guests, SpecialRequests) "
               "VALUES (%s, %s, %s, %s, %s, %s)")
        values = (
            data['CustomerID'],
            data['TableID'],
            data['RestaurantID'],
            data['ReservationTime'],
            data['Guests'],
            data.get('SpecialRequests', None)  # Optional, does not need to be inputted
        )
        
        cursor.execute(sql, values)
        db.commit()
        
        return jsonify({'message': 'Reservation created successfully'})

# Reservations{ReservationID}(refer to Reservations{id} on gradescope assignment 6 submission)
@reservations.route('/reservations/<int:reservationID>', methods=['GET', 'PUT', 'DELETE'])
def Reservations_post(ReservationID):
    cursor = db.get_db().cursor()
    if request.method == 'GET':
        cursor.execute("SELECT * FROM Reservations WHERE ReservationID = %s", (reservationID,))
        Reservation = cursor.fetchone()
        return jsonify(reservation)
    elif request.method == 'PUT':
        data = request.get_json()
        sql = (
            "UPDATE Reservations "
            "SET CustomerID = %s, TableID = %s, RestaurantID = %s, ReservationTime = %s, Guests = %s, SpecialRequests = %s "
            "WHERE ReservationID = %s"
        )
        values = (
            data['CustomerID'],
            data['TableID'],
            data['RestaurantID'],
            data['ReservationTime'],
            data['Guests'],
            data.get('SpecialRequests', None),
            ReservationID
        )
        cursor.execute(sql, values)
        db.commit()
        return jsonify({'message': 'Reservation updated successfully'})
    elif request.method == 'DELETE':
        cursor.execute("DELETE FROM Reservations WHERE ReservationID = %s", (ReservationID,))
        db.commit()
        return jsonify({'message': 'Reservation deleted successfully'})
