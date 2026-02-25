Feature: Get Booking

@happypath
Scenario: Obtener booking existente (happy)
  Given url 'https://restful-booker.herokuapp.com/booking'
  When method GET
  Then status 200
  And match response[0].bookingid != null

@happypath
Scenario: Obtener detalles de un booking existente
  Given url 'https://restful-booker.herokuapp.com/booking'
  When method GET
  Then status 200
  * def id = response[0].bookingid
  Given url 'https://restful-booker.herokuapp.com/booking/' + id
  When method GET
  Then status 200
  And match response.firstname != null
  And match response.lastname != null

@happypath
Scenario: Crear booking y verificar respuesta
  Given url 'https://restful-booker.herokuapp.com/booking'
  And header Content-Type = 'application/json'
  And request read('classpath:request/Resource.json')
  When method POST
  Then status 200
  And match response.bookingid != null
  And match response.booking != null

@happypath
Scenario: Crear booking y recuperarlo por id
  Given url 'https://restful-booker.herokuapp.com/booking'
  And header Content-Type = 'application/json'
  And request read('classpath:request/Resource.json')
  When method POST
  Then status 200
  * def newId = response.bookingid
  Given url 'https://restful-booker.herokuapp.com/booking/' + newId
  When method GET
  Then status 200
  And match response.firstname != null

  @unhappypath
Scenario: Obtener booking inexistente (unhappy)
  Given url 'https://restful-booker.herokuapp.com/booking/999999'
  When method GET
  Then status 404

@unhappypath
Scenario: Crear booking con datos incompletos
  Given url 'https://restful-booker.herokuapp.com/booking'
  And header Content-Type = 'application/json'
  And request { firstname: 'Juan' }
  When method POST
  Then status 400

@unhappypath
Scenario: Crear booking con campos vacíos
  Given url 'https://restful-booker.herokuapp.com/booking'
  And header Content-Type = 'application/json'
  And request { firstname: '', lastname: '', totalprice: 0, depositpaid: false }
  When method POST
  Then status 400

@unhappypath
Scenario: Crear booking con email inválido
  Given url 'https://restful-booker.herokuapp.com/booking'
  And header Content-Type = 'application/json'
  And request { firstname: 'Juan', lastname: 'Pérez', totalprice: 100, depositpaid: true, email: 'invalid-email', phone: '123456789' }
  When method POST
  Then status 400

@unhappypath
Scenario: Crear booking con checkin posterior a checkout
  Given url 'https://restful-booker.herokuapp.com/booking'
  And header Content-Type = 'application/json'
  And request { firstname: 'Juan', lastname: 'Pérez', totalprice: 100, depositpaid: true, bookingdates: { checkin: '2026-03-01', checkout: '2026-02-01' } }
  When method POST
  Then status 400

@unhappypath
Scenario: Obtener booking con ID string inválido
  Given url 'https://restful-booker.herokuapp.com/booking/abc123'
  When method GET
  Then status 404

@unhappypath
Scenario: Obtener booking con ID negativo
  Given url 'https://restful-booker.herokuapp.com/booking/-1'
  When method GET
  Then status 404

@unhappypath
Scenario: Crear booking sin content-type header
  Given url 'https://restful-booker.herokuapp.com/booking'
  And request read('classpath:request/Resource.json')
  When method POST
  Then status 400

@unhappypath
Scenario: Actualizar booking sin autorización
  Given url 'https://restful-booker.herokuapp.com/booking/1'
  And header Content-Type = 'application/json'
  And request { firstname: 'Usuario', lastname: 'Actualizado' }
  When method PUT
  Then status 403

@unhappypath
Scenario: Eliminar booking sin autorización
  Given url 'https://restful-booker.herokuapp.com/booking/1'
  When method DELETE
  Then status 403

@unhappypath
Scenario: Crear booking con total price negativo
  Given url 'https://restful-booker.herokuapp.com/booking'
  And header Content-Type = 'application/json'
  And request { firstname: 'Juan', lastname: 'Pérez', totalprice: -100, depositpaid: false }
  When method POST
  Then status 400