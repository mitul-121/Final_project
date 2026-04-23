<?php
    $servername = "dee-store-db";
    $username = "myappuser";
    $password = "StrongDbPassword2026!";
    $dbname = "myappdb";
    $port = 3306;  


    try {
      $conn = new PDO("mysql:host=$servername;dbname=$dbname;charset=utf8mb4", $username, $password);
      $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      echo "DB CONNECTED"; // debug
    } catch(PDOException $e) {
        die("Connection failed: " . $e->getMessage());
      }
?>