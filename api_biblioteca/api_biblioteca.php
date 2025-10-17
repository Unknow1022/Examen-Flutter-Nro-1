<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json; charset=utf-8');
require 'conexion.php';

$method = $_SERVER['REQUEST_METHOD'];

// Obtener id desde query string si existe: ?id=1
$id = isset($_GET['id']) ? intval($_GET['id']) : null;

// Helper: leer JSON del cuerpo (para PUT/POST)
$input = json_decode(file_get_contents('php://input'), true);

if ($method === 'GET') {
    if ($id) {
        // READ by ID
        $stmt = $pdo->prepare('SELECT * FROM libros WHERE id = ?');
        $stmt->execute([$id]);
        $libro = $stmt->fetch();
        if ($libro) {
            echo json_encode($libro);
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'Libro no encontrado']);
        }
    } else {
        // READ ALL
        $stmt = $pdo->query('SELECT * FROM libros ORDER BY id DESC');
        $libros = $stmt->fetchAll();
        echo json_encode($libros);
    }
    exit;
}

if ($method === 'POST') {
    // CREATE
    $titulo = trim($input['titulo'] ?? '');
    $autor = trim($input['autor'] ?? '');
    $isbn = trim($input['isbn'] ?? '');
    $categoria = trim($input['categoria'] ?? '');
    $año_publicacion = $input['año_publicacion'] ?? null;
    $disponible = isset($input['disponible']) ? (bool)$input['disponible'] : true;

    // Validaciones básicas
    if (!$titulo || !$autor || !$isbn || !$categoria || !$año_publicacion) {
        http_response_code(400);
        echo json_encode(['error' => 'Faltan campos obligatorios']);
        exit;
    }

    // ISBN único
    $stmt = $pdo->prepare('SELECT id FROM libros WHERE isbn = ?');
    $stmt->execute([$isbn]);
    if ($stmt->fetch()) {
        http_response_code(409);
        echo json_encode(['error' => 'ISBN ya existe']);
        exit;
    }

    $stmt = $pdo->prepare('INSERT INTO libros (titulo, autor, isbn, categoria, año_publicacion, disponible) VALUES (?, ?, ?, ?, ?, ?)');
    $stmt->execute([$titulo, $autor, $isbn, $categoria, $año_publicacion, $disponible]);
    $newId = $pdo->lastInsertId();

    http_response_code(201);
    echo json_encode(['message' => 'Libro creado', 'id' => $newId]);
    exit;
}

if ($method === 'PUT') {
    // UPDATE (id obligatorio)
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'ID requerido para actualizar']);
        exit;
    }

    $titulo = trim($input['titulo'] ?? '');
    $autor = trim($input['autor'] ?? '');
    $isbn = trim($input['isbn'] ?? '');
    $categoria = trim($input['categoria'] ?? '');
    $año_publicacion = $input['año_publicacion'] ?? null;
    $disponible = isset($input['disponible']) ? (bool)$input['disponible'] : true;

    if (!$titulo || !$autor || !$isbn || !$categoria || !$año_publicacion) {
        http_response_code(400);
        echo json_encode(['error' => 'Faltan campos obligatorios']);
        exit;
    }

    // Verificar ISBN único (excluyendo este id)
    $stmt = $pdo->prepare('SELECT id FROM libros WHERE isbn = ? AND id <> ?');
    $stmt->execute([$isbn, $id]);
    if ($stmt->fetch()) {
        http_response_code(409);
        echo json_encode(['error' => 'ISBN ya registrado por otro libro']);
        exit;
    }

    $stmt = $pdo->prepare('UPDATE libros SET titulo=?, autor=?, isbn=?, categoria=?, año_publicacion=?, disponible=? WHERE id=?');
    $stmt->execute([$titulo, $autor, $isbn, $categoria, $año_publicacion, $disponible, $id]);

    echo json_encode(['message' => 'Libro actualizado']);
    exit;
}

if ($method === 'DELETE') {
    // DELETE (id obligatorio)
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'ID requerido para eliminar']);
        exit;
    }

    $stmt = $pdo->prepare('DELETE FROM libros WHERE id = ?');
    $stmt->execute([$id]);

    echo json_encode(['message' => 'Libro eliminado']);
    exit;
}

// Método no soportado
http_response_code(405);
echo json_encode(['error' => 'Método no soportado']);
