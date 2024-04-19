<?php

	$codigo =  $_POST['id_especialidade'];  
	
	require('acesso.php');	
	
	$sql = "call prc_duplicar_especialidade('$codigo');" ;

	try {	
		$conn->query($sql) ; 	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
	
	$conn->close();	

	// echo $sql;
		
?>