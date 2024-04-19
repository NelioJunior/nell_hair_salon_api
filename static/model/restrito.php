<?php

	require('../../../dummy.php');		

	$senha = $_POST["senha"];
	$itemMenu = $_POST["itemMenu"];

	$jsonFromSrv = file_get_contents('./jsonFiles/configuracao.json');
	$config = json_decode($jsonFromSrv, true);
    $nameUsuario = $config['nomeUsuario'];
    
    if ($senha == "") {
        die("Senha em branco.Entre com uma senha válida");        
    } else {        	 
    	$senhaNaoEncontrada = true;
		foreach($json->reservadas as $item){
			if($item->userFinanceiro == $nameUsuario && $item->senhaFinanceiro == $senha)	{
				$senhaNaoEncontrada = false ;			
			}		
		}	
		
		if ($senhaNaoEncontrada) {
			die("Senha não localizada. Verifique se você digitou a senha corretamente.");
		}
       
        if ($itemMenu == "configuracao") {
        	echo "frmconfiguracao_acesso_restrito.php"; 
        } elseif ($itemMenu == "grafico") {
        	echo "frmgrafico_acesso_restrito.php"; 
        } elseif ($itemMenu == "financeiro") {
        	echo "relatoriofinanceiro_acesso_restrito.php"; 
        } else {
            echo "listaagenda.php"; 
        }      
    }   

?>