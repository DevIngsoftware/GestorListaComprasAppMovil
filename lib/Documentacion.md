Documentación de la API - Lista de Compras
Base URL
https://api.miapp.com/api/v1

1️⃣ Autenticación
1.1 Login

URL: /auth/login

Método: POST

Headers: Content-Type: application/json

Body:
{
  "email": "usuario@example.com",
  "password": "password123"
}
Respuesta exitosa:

{
  "accessToken": "jwt_token_aqui",
  "user": {
    "id": 1,
    "name": "Nombre Usuario",
    "email": "usuario@example.com"
  }
}


Errores posibles:

401: Credenciales inválidas

1.2 Registro

URL: /auth/register

Método: POST

Headers: Content-Type: application/json

Body:

{
  "name": "Nombre Usuario",
  "email": "usuario@example.com",
  "password": "password123"
}


Respuesta exitosa: Igual que el login (puede retornar token o requerir login posterior)

Errores posibles:

400: Email ya registrado

2️⃣ Productos de la Lista de Compras

Todas las rutas requieren Authorization header:

Authorization: Bearer <token>

2.1 Obtener productos

URL: /products

Método: GET

Respuesta exitosa:

[
  {
    "id": 1,
    "name": "Leche",
    "quantity": 2,
    "note": "Sin lactosa",
    "acquired": false
  },
  {
    "id": 2,
    "name": "Pan",
    "quantity": 1,
    "note": "",
    "acquired": true
  }
]

2.2 Agregar producto

URL: /products

Método: POST

Body:

{
  "name": "Huevos",
  "quantity": 12,
  "note": "Orgánicos",
  "acquired": false
}


Respuesta exitosa:

{
  "id": 3,
  "name": "Huevos",
  "quantity": 12,
  "note": "Orgánicos",
  "acquired": false
}

2.3 Actualizar producto

URL: /products/{id}

Método: PUT

Body:

{
  "name": "Huevos",
  "quantity": 12,
  "note": "Orgánicos",
  "acquired": true
}


Respuesta exitosa: Producto actualizado igual que el body con id incluido.

2.4 Eliminar producto

URL: /products/{id}

Método: DELETE

Respuesta exitosa: 204 No Content

2.5 Cambiar estado “adquirido”

Puede usarse el mismo PUT /products/{id} actualizando el campo acquired.

3️⃣ Modelo de Producto
{
  "id": 1,
  "name": "Nombre del producto",
  "quantity": 1,
  "note": "Opcional",
  "acquired": false
}

4️⃣ Notas importantes

Todos los endpoints de productos requieren token JWT válido.

Content-Type siempre application/json.

Para futuras mejoras:

Paginación: /products?page=1&limit=20

Filtros: /products?acquired=false