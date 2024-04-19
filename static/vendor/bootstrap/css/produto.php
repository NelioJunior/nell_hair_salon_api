<?php
	

	$codigo = $_POST['codigo'];   
	$nome =   $_POST['nome'];   
	$preco = $_POST['preco'];
	$fornecedor = $_POST['fornecedor'];
	$quantidade = $_POST['quantidade'];	
	


	require('acesso.php');	
			
	$sql = "call prc_atualizar_produto ('{$codigo}','{$nome}','{$fornecedor}','{$quantidade}','{$preco}');" ;

	try {	
		$conn->query("$sql") ; 	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
					
	$conn->close();
		
?>