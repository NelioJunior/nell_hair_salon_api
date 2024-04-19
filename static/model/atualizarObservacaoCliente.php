<?php

    //python
    $getJson = json_decode(file_get_contents("php://input"));

    //php
    if (isset($_POST["jsonParametros"])) {
       $getJson = json_decode($_POST['jsonParametros']);
    }

    $parametros = "";

    foreach ($getJson as $value) {
        $parametros .= utf8_decode("'{$value}',");
    }

    $parametros = substr($parametros, 0, -1);

    $sql = "call prc_atualizar_observacao_cliente ($parametros);";

	require('acesso.php');

	try {
		$conn->query($sql) ;

		$result = mysqli_query($conn, "select max(id_agenda) id_agenda from agenda;");
		$row = mysqli_fetch_array($result);
		echo $row["id_agenda"];

	} catch (PDOException $e){
		echo $e->getMessage();
	}

	$conn->close();
?>
