<?php
    $servername = "dee-store-db";
    $username = "myappuser";
    $password = "StrongAdminPass2026!";
    $dbname = "myappdb";
    
    try {
      $conn = new PDO("mysql:host=$servername; dbname=$dbname", $username, $password);
      $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    } catch(PDOException $e) {
      die;
    }
?>