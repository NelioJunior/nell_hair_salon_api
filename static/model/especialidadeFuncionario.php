<?php

 	$itensEspecialidade =  json_decode($_POST['jsonParametros']);

	require('acesso.php');	
	
	$sql = "call prc_deletar_especialidade_do_funcionario ({$itensEspecialidade[0]->id_funcionario});";		

	$conn->query($sql); 	
	
    foreach($itensEspecialidade as $item) {
		$sql = "call prc_atualizar_especialidade_do_funcionario ({$item->id_funcionario},{$item->id_especialidade});";		

		$conn->query($sql) ; 	
    }
	
	$conn->close();
		
?>