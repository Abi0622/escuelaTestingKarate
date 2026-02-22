
Feature: Automatizar el backend de Pet Store
  Background:
    * url apiPetStore
    * def jsonCrearMascota = read('classpath:examples/json/crearmascota.json')
    * def jsonEditMascota = read('classpath:examples/json/actualizarMascota.json')

   @TEST-1 @crearMascota
  Scenario: Verificar la creacion de una nueva mascota en Pet Store - OK

    Given path 'pet'
    And request jsonCrearMascota
    When method post
    Then status 200
     And match response.id == 14
     And match response.name == 'Max'
     And match response.status == 'available'
     * def idPet = response.id
    And print idPet

  @TEST-2
  Scenario: Verificar el estado de la mascota que se ha creado anteriormente - OK

    Given path 'pet/findByStatus'
    And param status = 'available'
    When method get
    Then status 200
    And print response


  @TEST-3
  Scenario Outline: Verificar el estado de la mascota <estado>
    Given path 'pet/findByStatus'
    And param status = '<estado>'
    When method get
    Then status 200
    And print response

    Examples:
      | estado    |
      | available |
      | sold      |
      | pending   |

  @TEST-4
  Scenario: Verificar la actualizacion de una mascota en Pet store previamente registrada - OK

    Given path 'pet'
    And request jsonEditMascota.id = '3'
    And request jsonEditMascota.name = 'Sassy'
    And request jsonEditMascota.status = 'sold'
    And request jsonEditMascota
    When method put
    Then status 200
    And print response

  @TEST-5
  Scenario Outline: Verificar mascota por ID
    Given path 'pet/'+'<idPet>'
    When method get
    Then status 200
    And print response
    Examples:
      |   idPet               |
      |  9223372036854775807  |


  @TEST-6
  Scenario Outline: Eliminar la mascota por ID - OK
    Given path 'pet/'+'<idPet>'
    When method delete
    Then status 200
    And print response

    Examples:
      |   idPet               |
      |  9223372036854775807  |
  @TEST-7
  Scenario: Subir una imagen para una mascota existente
    * def petId = 999

    Given path 'pet', petId, 'uploadImage'
    And multipart file file = { read: 'perrito.jpg', filename: 'perrito.jpg', contentType: 'image/jpeg' }
    And multipart field additionalMetadata = 'Foto de perfil actualizada'
    When method post
    Then status 200
    And match response.message contains 'perrito.jpg'


  # When method get
    # Then status 200
    # And match response contains user

# Llamar a otro caso de prueba para usarlo despues

  @TEST-8
  Scenario: Verificar la busqueda de la mascota por id - OK
    * def idMascota = call read('classpath:examples/users/users.feature@crearMascota')
    Given path 'pet/'+ idMascota.idPet
    When method get
    Then status 200
    And print response