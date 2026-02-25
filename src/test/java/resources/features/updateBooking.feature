Feature: Update Booking

Background:
  * url 'https://restful-booker.herokuapp.com'

  # Obtener token
  * path 'auth'
  * request { username: 'admin', password: 'password123' }
  * method POST
  * def token = response.token

  # Crear booking
  * path 'booking'
  * request
    """
    {
      "firstname": "Juan",
      "lastname": "Perez",
      "totalprice": 100,
      "depositpaid": true,
      "bookingdates": {
        "checkin": "2024-01-01",
        "checkout": "2024-01-05"
      },
      "additionalneeds": "Breakfast"
    }
    """
  * method POST
  * def bookingId = response.bookingid

Scenario: Update booking (happy)
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Carlos",
    "lastname": "Lopez",
    "totalprice": 200,
    "depositpaid": false,
    "bookingdates": {
      "checkin": "2024-02-01",
      "checkout": "2024-02-10"
    },
    "additionalneeds": "Dinner"
  }
  """
  When method PUT
  Then status 200
  And match response.firstname == "Carlos"

Scenario: Update sin token (unhappy)
  Given path 'booking', bookingId
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Test",
    "lastname": "Test",
    "totalprice": 100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-01-01",
      "checkout": "2024-01-02"
    },
    "additionalneeds": "None"
  }
  """
  When method PUT
  Then status 403

@happypath
Scenario: Actualizar solo nombre del booking
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Miguel",
    "lastname": "Perez",
    "totalprice": 100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-01-01",
      "checkout": "2024-01-05"
    },
    "additionalneeds": "Breakfast"
  }
  """
  When method PUT
  Then status 200
  And match response.firstname == "Miguel"

@happypath
Scenario: Actualizar precio del booking
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Juan",
    "lastname": "Perez",
    "totalprice": 350,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-01-01",
      "checkout": "2024-01-05"
    },
    "additionalneeds": "Breakfast"
  }
  """
  When method PUT
  Then status 200
  And match response.totalprice == 350

@happypath
Scenario: Actualizar fechas del booking
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Juan",
    "lastname": "Perez",
    "totalprice": 100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-03-15",
      "checkout": "2024-03-20"
    },
    "additionalneeds": "Breakfast"
  }
  """
  When method PUT
  Then status 200
  And match response.bookingdates.checkin == "2024-03-15"

@happypath
Scenario: Actualizar booking y verificar persistencia
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Roberto",
    "lastname": "Martinez",
    "totalprice": 250,
    "depositpaid": false,
    "bookingdates": {
      "checkin": "2024-02-01",
      "checkout": "2024-02-05"
    },
    "additionalneeds": "Lunch"
  }
  """
  When method PUT
  Then status 200
  Given path 'booking', bookingId
  When method GET
  Then status 200
  And match response.firstname == "Roberto"

@unhappypath
Scenario: Actualizar con token inválido
  Given path 'booking', bookingId
  And header Cookie = 'token=invalid_token_xyz'
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Test",
    "lastname": "Test",
    "totalprice": 100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-01-01",
      "checkout": "2024-01-02"
    },
    "additionalneeds": "None"
  }
  """
  When method PUT
  Then status 403

@unhappypath
Scenario: Actualizar booking inexistente
  Given path 'booking/999999'
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Test",
    "lastname": "Test",
    "totalprice": 100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-01-01",
      "checkout": "2024-01-02"
    },
    "additionalneeds": "None"
  }
  """
  When method PUT
  Then status 404

@unhappypath
Scenario: Actualizar con datos incompletos
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request { firstname: 'Test' }
  When method PUT
  Then status 400

@unhappypath
Scenario: Actualizar con campos vacíos
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "",
    "lastname": "",
    "totalprice": 100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-01-01",
      "checkout": "2024-01-02"
    },
    "additionalneeds": ""
  }
  """
  When method PUT
  Then status 400

@unhappypath
Scenario: Actualizar con fechas inválidas (checkout anterior a checkin)
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Juan",
    "lastname": "Perez",
    "totalprice": 100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-05-01",
      "checkout": "2024-04-01"
    },
    "additionalneeds": "Breakfast"
  }
  """
  When method PUT
  Then status 400

@unhappypath
Scenario: Actualizar con precio negativo
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And header Content-Type = 'application/json'
  And request
  """
  {
    "firstname": "Juan",
    "lastname": "Perez",
    "totalprice": -100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-01-01",
      "checkout": "2024-01-05"
    },
    "additionalneeds": "Breakfast"
  }
  """
  When method PUT
  Then status 400

@unhappypath
Scenario: Actualizar sin Content-Type header
  Given path 'booking', bookingId
  And header Cookie = 'token=' + token
  And request
  """
  {
    "firstname": "Test",
    "lastname": "Test",
    "totalprice": 100,
    "depositpaid": true,
    "bookingdates": {
      "checkin": "2024-01-01",
      "checkout": "2024-01-02"
    },
    "additionalneeds": "None"
  }
  """
  When method PUT
  Then status 400