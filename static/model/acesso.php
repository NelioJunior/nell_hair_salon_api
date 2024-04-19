<?php

    require 'vendor/autoload.php';

	$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
	$dotenv->load();

	$user = $_ENV["BANCO_USUARIO"] ;
	$pws = $_ENV["BANCO_SENHA"] ;
	$site = $_ENV["BANCO_SITE"] ;
	$banco = $_ENV["BANCO_NOME"] ;

	$conn = new mysqli($site, $user, $pws, $banco);
        $conn->set_charset("utf8");

	if ($conn->connect_error) {
	    die("Connection failed: " . $conn->connect_error);
	}

?>
