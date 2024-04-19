<?php 

	/*
		http://localhost/mysite/ClientesParceirosNell/gestorPai_SalaoConsultorio/buscarfluxoCaixaMes.php?mes=7&ano=2019
	*/
	
	header('Content-Type: text/html; charset=utf-8'); 
	require('acesso.php');	

	$conn->set_charset("utf8");
	
	$mes = $_GET["mes"];
	$ano = $_GET["ano"];
	
	$query = "call prc_buscar_fluxo_Caixa_Mes($mes,$ano)";
			
	try {	

		$result = mysqli_query($conn, $query);
			
		$rows = array();
			
		while($each = mysqli_fetch_assoc($result)){
			$rows[] = $each;
		}
						
		echo json_encode($rows); 
	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
				
	$conn->close();
		
?>