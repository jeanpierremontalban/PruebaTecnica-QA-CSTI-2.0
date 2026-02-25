Feature: Auth - Create Token

Scenario: Crear token válido
  Given url baseUrl + '/auth'
  And request { username: 'admin', password: 'password123' }
  When method POST
  Then status 200
  And match response.token != null

Scenario: Credenciales inválidas
  Given url baseUrl + '/auth'
  And request { username: 'admin', password: 'wrong' }
  When method POST
  Then status 200
  And match response.reason == 'Bad credentials'

Scenario: Usuario no encontrado
  Given url baseUrl + '/auth'
  And request { username: 'usuarioNoExiste', password: 'password123' }
  When method POST
  Then status 200
  And match response.reason == 'User does not exist'

Scenario: Usuario sin contraseña
  Given url baseUrl + '/auth'
  And request { username: 'admin' }
  When method POST
  Then status 400
  And match response.reason == 'Password required'

Scenario: Solicitud sin usuario
  Given url baseUrl + '/auth'
  And request { password: 'password123' }
  When method POST
  Then status 400
  And match response.reason == 'Username required'

Scenario: Campos vacíos
  Given url baseUrl + '/auth'
  And request { username: '', password: '' }
  When method POST
  Then status 200
  And match response.reason == 'Bad credentials'

Scenario: Token válido en Headers
  Given url baseUrl + '/auth'
  And header Authorization = 'Bearer valid_token_123'
  When method GET
  Then status 200
  And match response.user != null

Scenario: Token inválido en Headers
  Given url baseUrl + '/auth'
  And header Authorization = 'Bearer invalid_token'
  When method GET
  Then status 401
  And match response.reason == 'Unauthorized'