<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Salão de beleza</title>
    <link href="vendor/bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
    <link href="css/sb-admin.css" rel="stylesheet">
    <link href="css/nellstyle.css" rel="stylesheet">

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0" />

    <link href="css/chat.css" rel="stylesheet"> 
  	<script src="./vendor/js/jquery.min.js"></script>
    <script src="./vendor/js/tools.js"></script>

    <style>
		body { 
		  background: url(img/wallpaper.jpg) no-repeat center center fixed; 
		  -webkit-background-size: cover;
		  -moz-background-size: cover;
		  -o-background-size: cover;
		  background-size: cover;
		  margin:5x
		}
        
        .ScrollDiv {
            height: 100px;
            border: 1px solid #cccccc;
            border-radius: 10px 0px 0px 10px;
            overflow-y: scroll;
            overflow-x: hidden;
        }
    </style>
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
		<a class="navbar-brand"><img src="./img/logo.png" style="width:55px"></a>
        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <ul class="navbar-nav navbar-sidenav">
                <li class="nav-item">
					<br><br>
                    <a class="nav-link  collapsed" data-toggle="collapse" onclick="$('#collapseAgenda').collapse('toggle')">
                        <i class="fa fa-fw fa-address-book-o "></i>
                        <span class="nav-link-text">Agenda</span>
                    </a>    
                    <ul class="sidenav-second-level collapse" id="collapseAgenda">					
                        <li>
                            <a onclick="location.href='listaagenda.php'" class="subitem">Lista de agendamentos</a>
                        </li>
                        <li>
                            <a onclick="location.href='listacliente.php'" class="subitem">Lista de clientes</a>
                        </li>
                        <li>
                            <a onclick="location.href='listaferiado.php'" class="subitem">Lista de feriados</a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link collapsed" data-toggle="collapse" onclick="$('#collapsefunc').collapse('toggle')">
                        <i class="fa fa-fw fa-users "></i>
                        <span class="nav-link-text">Recursos Humanos</span>
                    </a>
                    <ul class="sidenav-second-level collapse" id="collapsefunc">
                        <li>
                            <a onclick="location.href='listafuncionario.php'" class="subitem">Lista de  funcionários</a>
                        </li>

                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link collapsed" data-toggle="collapse" onclick="$('#collapseEstoque').collapse('toggle')">
                        <i class="fa fa-archive "></i>
                        <span class="nav-link-text">Estoque</span>
                    </a>
                    <ul class="sidenav-second-level collapse" id="collapseEstoque">
                        <li>
                            <a onclick="location.href='listafornecedor.php'" class="subitem">Lista de fornecedores</a>
                        </li>
                        <li>
                            <a onclick="location.href='listaproduto.php'" class="subitem">Lista de produtos</a>
                        </li>						
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link collapsed" data-toggle="collapse" onclick="$('#collapseEspecialidade').collapse('toggle')" >
                        <i class="fa fa-scissors"></i>
                        <span class="nav-link-text">Especialidade</span>
                    </a>
                    <ul class="sidenav-second-level collapse" id="collapseEspecialidade">
                        <li>
                            <a onclick="location.href='listaespecialidade.php'" class="subitem">lista de especialidades</a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link collapsed" data-toggle="collapse" onclick="$('#collapseFinanceiro').collapse('toggle')" >
                        <i class="fa fa-usd"></i>
                        <span class="nav-link-text">Financeiro</span>
                    </a>
                    <ul class="sidenav-second-level collapse" id="collapseFinanceiro">
                        <li>
                            <a onclick="location.href='listafluxocaixa.php'" class="subitem">Fluxo de Caixa</a>
                        </li>
                        <li>
                            <a onclick="location.href='restrito.php?itemMenu=financeiro'" class="subitem">Relatório Financeiro</a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link collapsed" data-toggle="collapse" onclick="$('#collapsePromo').collapse('toggle')" >
                        <i class="fa fa-whatsapp"></i>
                        <span class="nav-link-text">Promoções</span>
                    </a>
                    <ul class="sidenav-second-level collapse" id="collapsePromo">
                        <li>
                            <a onclick="location.href='listagrupo.php'" class="subitem">Grupos</a>
                        </li>
                        <li>
                            <a onclick="location.href='listacampanha.php'" class="subitem">Campanhas</a>
                        </li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a class="nav-link collapsed" data-toggle="collapse" onclick="$('#collapseConfig').collapse('toggle')">
                        <i class="fa fa-cogs fa-1x"></i>
                        <span class="nav-link-text">Administração</span>
                    </a>
                    <ul class="sidenav-second-level collapse" id="collapseConfig">
                        <li>
                            <a  onclick="location.href='listaimportacao.php'" class="subitem">Importação</a>
                        </li>
                        <li>
                            <!--a onclick="location.href='restrito.php?itemMenu=grafico'" class="subitem">Gráficos de Produtividade</a-->
                            <a onclick="location.href='frmgrafico_acesso_restrito.php'" class="subitem">Gráficos de Produtividade</a>
                        </li>
                        <li>
                            <!-- a onclick="location.href='restrito.php?itemMenu=configuracao'"  class="subitem">configuração</a-->
                            <a onclick="location.href='frmconfiguracao_acesso_restrito.php'" class="subitem">configuração</a>
                        </li>
                    </ul>
                </li>
            </ul>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="https://nelltek.com.br/">
                        <i class="fa fa-fw fa-sign-out"></i>Logout</a>
                </li>

            </ul>
            <ul class="navbar-nav sidenav-toggler">
                <li class="nav-item">
                    <a class="nav-link text-center" id="sidenavToggler">
                        <i class="fa fa-fw fa-angle-left"></i>
                    </a>
                </li>
            </ul>
    </nav>

    <script>
    	var flagmenu = true;

		$("#sidenavToggler").click(function(){ 
			 if (flagmenu) {
				$(".subitem").hide() 
			 } else {
				$(".subitem").show() 
			 } 	
			 flagmenu = !flagmenu					
		})

        $(".nav-link > .fa").click(function(){ 
            if (flagmenu == false) {
                sidenavToggler.click();                
            }    
        })

    </script>
