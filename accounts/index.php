<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include "../config/db.php";

$method = $_SERVER['REQUEST_METHOD'];
if ($method === 'POST' && isset($_POST['_method'])) {
    $method = strtoupper($_POST['_method']);
    // echo json_encode("method: " . $method);
}

switch($method){
    case "GET":
        $sql = "SELECT ID, created_at, username, isAdmin FROM account";
        $result = mysqli_query($conn, $sql);
        $rows = [];
       
        if ($result) {
            while ($row = $result->fetch_assoc()) {
                $rows[] = $row;
            }
        }
        
        echo json_encode(["status" => "success", "data" => $rows]);
    break;

    case "POST":
        // Validasi input
        if (!isset($_POST['username']) || !isset($_POST['password'])) {
            echo json_encode(["status" => "error", "message" => "Username dan password harus diisi"]);
            break;
        }

        $username = $conn->real_escape_string($_POST['username']);
        $password = $conn->real_escape_string($_POST['password']);

        // Cek apakah username ada
        $sql = "SELECT ID, password, username, isAdmin FROM account WHERE username = '$username'";
        $result = mysqli_query($conn, $sql);
        
        if (!$result || $result->num_rows === 0) {
            echo json_encode(["status" => "error", "message" => "Username atau password salah"]);
            break;
        }

        $row = $result->fetch_assoc();
        $hash = $row['password'];
        
        // Verify password
        if (!password_verify($password, $hash)) {
            echo json_encode(["status" => "error", "message" => "Username atau password salah"]);
            break;
        }

        // Generate session token
        $sessionToken = bin2hex(random_bytes(32)); // Generate random token
        $sessionExpiry = time() + (24 * 60 * 60); // 24 jam

        // Save session ke database (optional, untuk tracking)
        $updateSessionSql = "UPDATE account SET session_token = '$sessionToken', session_expiry = FROM_UNIXTIME($sessionExpiry) WHERE ID = '{$row['ID']}'";
        mysqli_query($conn, $updateSessionSql);

        // Set HTTP-only cookie (aman dari XSS)
        setcookie(
            'session', 
            $sessionToken, 
            $sessionExpiry, 
            '/', 
            '', 
            false, // Tidak HTTPS untuk development
            true   // HTTP-only (tidak bisa diakses dari JavaScript)
        );

        // Juga set cookie yang bisa diakses JavaScript jika diperlukan
        setcookie(
            'user_info',
            json_encode(['id' => $row['ID'], 'username' => $row['username'], 'isAdmin' => $row['isAdmin']]),
            $sessionExpiry,
            '/',
            '',
            false,
            false // Bisa diakses dari JavaScript
        );

        // Response success
        echo json_encode([
            "status" => "success", 
            "message" => "Login berhasil",
            "data" => [
                "ID" => $row['ID'],
                "username" => $row['username'],
                "isAdmin" => $row['isAdmin'],
                "session_token" => $sessionToken
            ]
        ]);
    break;

    case "PUT":
        // Validasi input dari $_POST
        if (!isset($_POST['current_password']) || !isset($_POST['new_password']) || !isset($_POST['current_username'])) {
            echo json_encode(["status" => "error", "message" => "Username, current password, dan new password harus diisi"]);
            break;
        }

        $username = $conn->real_escape_string($_POST['current_username']);
        $currentPassword = $_POST['current_password'];
        $newPassword = $_POST['new_password'];

        $changeUsername = $conn->real_escape_string($_POST['username']);

        // Cek user
        $sql = "SELECT ID, password FROM account WHERE username = '$username'";
        $result = mysqli_query($conn, $sql);

        if (!$result || $result->num_rows === 0) {
            echo json_encode(["status" => "error", "message" => "User tidak ditemukan"]);
            break;
        }

        $row = $result->fetch_assoc();
        $hash = $row['password'];

        // Verifikasi current password
        if (!password_verify($currentPassword, $hash)) {
            echo json_encode(["status" => "error", "message" => "Password lama salah"]);
            break;
        }

        // Hash password baru
        $newHash = password_hash($newPassword, PASSWORD_DEFAULT, ['cost' => 12]);

        // Prepare statement for update query
        $updateStmt = mysqli_prepare($conn, "UPDATE account SET password = ?, username = ? WHERE ID = ?");

        // Bind parameters to the statement
        mysqli_stmt_bind_param($updateStmt, "sss", $newHash, $changeUsername, $row['ID']);

        // Execute the statement
        if (mysqli_stmt_execute($updateStmt)) {
            echo json_encode(["status" => "success", "message" => "Password dan username berhasil diupdate", "data" => ["username" => $changeUsername]]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal update password dan username: " . mysqli_stmt_error($updateStmt)]);
        }

        // Close the statement
        mysqli_stmt_close($updateStmt);
    break;
    
    default:
        echo json_encode(["status" => "error", "message" => "Unsupported method"]);
        break;
}