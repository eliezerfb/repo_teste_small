unit uListaCnaes;

interface

  function getListaCnae:string;

implementation

function getListaCnae:string;
begin
  Result := '0111301 - Cultivo de arroz'+#13#10+
            '0111302 - Cultivo de milho'+#13#10+
            '0111303 - Cultivo de trigo'+#13#10+
            '0111399 - Cultivo de outros cereais n�o especificados anteriormente'+#13#10+
            '0112101 - Cultivo de algod�o herb�ceo'+#13#10+
            '0112102 - Cultivo de juta'+#13#10+
            '0112199 - Cultivo de outras fibras de lavoura tempor�ria n�o especificadas anteriormente'+#13#10+
            '0113000 - Cultivo de cana-de-a��car'+#13#10+
            '0114800 - Cultivo de fumo'+#13#10+
            '0115600 - Cultivo de soja'+#13#10+
            '0116401 - Cultivo de amendoim'+#13#10+
            '0116402 - Cultivo de girassol'+#13#10+
            '0116403 - Cultivo de mamona'+#13#10+
            '0116499 - Cultivo de outras oleaginosas de lavoura tempor�ria n�o especificadas anteriormente'+#13#10+
            '0119901 - Cultivo de abacaxi'+#13#10+
            '0119902 - Cultivo de alho'+#13#10+
            '0119903 - Cultivo de batata-inglesa'+#13#10+
            '0119904 - Cultivo de cebola'+#13#10+
            '0119905 - Cultivo de feij�o'+#13#10+
            '0119906 - Cultivo de mandioca'+#13#10+
            '0119907 - Cultivo de mel�o'+#13#10+
            '0119908 - Cultivo de melancia'+#13#10+
            '0119909 - Cultivo de tomate rasteiro'+#13#10+
            '0119999 - Cultivo de outras plantas de lavoura tempor�ria n�o especificadas anteriormente'+#13#10+
            '0121101 - Horticultura, exceto morango'+#13#10+
            '0121102 - Cultivo de morango'+#13#10+
            '0122900 - Cultivo de flores e plantas ornamentais'+#13#10+
            '0131800 - Cultivo de laranja'+#13#10+
            '0132600 - Cultivo de uva'+#13#10+
            '0133401 - Cultivo de a�a�'+#13#10+
            '0133402 - Cultivo de banana'+#13#10+
            '0133403 - Cultivo de caju'+#13#10+
            '0133404 - Cultivo de c�tricos, exceto laranja'+#13#10+
            '0133405 - Cultivo de coco-da-ba�a'+#13#10+
            '0133406 - Cultivo de guaran�'+#13#10+
            '0133407 - Cultivo de ma��'+#13#10+
            '0133408 - Cultivo de mam�o'+#13#10+
            '0133409 - Cultivo de maracuj�'+#13#10+
            '0133410 - Cultivo de manga'+#13#10+
            '0133411 - Cultivo de p�ssego'+#13#10+
            '0133499 - Cultivo de frutas de lavoura permanente n�o especificadas anteriormente'+#13#10+
            '0134200 - Cultivo de caf�'+#13#10+
            '0135100 - Cultivo de cacau'+#13#10+
            '0139301 - Cultivo de ch�-da-�ndia'+#13#10+
            '0139302 - Cultivo de erva-mate'+#13#10+
            '0139303 - Cultivo de pimenta-do-reino'+#13#10+
            '0139304 - Cultivo de plantas para condimento, exceto pimenta-do-reino'+#13#10+
            '0139305 - Cultivo de dend�'+#13#10+
            '0139306 - Cultivo de seringueira'+#13#10+
            '0139399 - Cultivo de outras plantas de lavoura permanente n�o especificadas anteriormente'+#13#10+
            '0141501 - Produ��o de sementes certificadas, exceto de forrageiras para pasto'+#13#10+
            '0141502 - Produ��o de sementes certificadas de forrageiras para forma��o de pasto'+#13#10+
            '0142300 - Produ��o de mudas e outras formas de propaga��o vegetal, certificadas'+#13#10+
            '0151201 - Cria��o de bovinos para corte'+#13#10+
            '0151202 - Cria��o de bovinos para leite'+#13#10+
            '0151203 - Cria��o de bovinos, exceto para corte e leite'+#13#10+
            '0152101 - Cria��o de bufalinos'+#13#10+
            '0152102 - Cria��o de equinos'+#13#10+
            '0152103 - Cria��o de asininos e muares'+#13#10+
            '0153901 - Cria��o de caprinos'+#13#10+
            '0153902 - Cria��o de ovinos, inclusive para produ��o de l�'+#13#10+
            '0154700 - Cria��o de su�nos'+#13#10+
            '0155501 - Cria��o de frangos para corte'+#13#10+
            '0155502 - Produ��o de pintos de um dia'+#13#10+
            '0155503 - Cria��o de outros galin�ceos, exceto para corte'+#13#10+
            '0155504 - Cria��o de aves, exceto galin�ceos'+#13#10+
            '0155505 - Produ��o de ovos'+#13#10+
            '0159801 - Apicultura'+#13#10+
            '0159802 - Cria��o de animais de estima��o'+#13#10+
            '0159803 - Cria��o de escarg�'+#13#10+
            '0159804 - Cria��o de bicho-da-seda'+#13#10+
            '0159899 - Cria��o de outros animais n�o especificados anteriormente'+#13#10+
            '0161001 - Servi�o de pulveriza��o e controle de pragas agr�colas'+#13#10+
            '0161002 - Servi�o de poda de �rvores para lavouras'+#13#10+
            '0161003 - Servi�o de prepara��o de terreno, cultivo e colheita'+#13#10+
            '0161099 - Atividades de apoio � agricultura n�o especificadas anteriormente'+#13#10+
            '0162801 - Servi�o de insemina��o artificial em animais'+#13#10+
            '0162802 - Servi�o de tosquiamento de ovinos'+#13#10+
            '0162803 - Servi�o de manejo de animais'+#13#10+
            '0162899 - Atividades de apoio � pecu�ria n�o especificadas anteriormente'+#13#10+
            '0163600 - Atividades de p�s-colheita'+#13#10+
            '0170900 - Ca�a e servi�os relacionados'+#13#10+
            '0210101 - Cultivo de eucalipto'+#13#10+
            '0210102 - Cultivo de ac�cia-negra'+#13#10+
            '0210103 - Cultivo de pinus'+#13#10+
            '0210104 - Cultivo de teca'+#13#10+
            '0210105 - Cultivo de esp�cies madeireiras, exceto eucalipto, ac�cia-negra, pinus e teca'+#13#10+
            '0210106 - Cultivo de mudas em viveiros florestais'+#13#10+
            '0210107 - Extra��o de madeira em florestas plantadas'+#13#10+
            '0210108 - Produ��o de carv�o vegetal - florestas plantadas'+#13#10+
            '0210109 - Produ��o de casca de ac�cia-negra - florestas plantadas'+#13#10+
            '0210199 - Produ��o de produtos n�o madeireiros n�o especificados anteriormente em florestas plantadas'+#13#10+
            '0220901 - Extra��o de madeira em florestas nativas'+#13#10+
            '0220902 - Produ��o de carv�o vegetal - florestas nativas'+#13#10+
            '0220903 - Coleta de castanha-do-par� em florestas nativas'+#13#10+
            '0220904 - Coleta de l�tex em florestas nativas'+#13#10+
            '0220905 - Coleta de palmito em florestas nativas'+#13#10+
            '0220906 - Conserva��o de florestas nativas'+#13#10+
            '0220999 - Coleta de produtos n�o madeireiros n�o especificados anteriormente em florestas nativas'+#13#10+
            '0230600 - Atividades de apoio � produ��o florestal'+#13#10+
            '0311601 - Pesca de peixes em �gua salgada'+#13#10+
            '0311602 - Pesca de crust�ceos e moluscos em �gua salgada'+#13#10+
            '0311603 - Coleta de outros produtos marinhos'+#13#10+
            '0311604 - Atividades de apoio � pesca em �gua salgada'+#13#10+
            '0312401 - Pesca de peixes em �gua doce'+#13#10+
            '0312402 - Pesca de crust�ceos e moluscos em �gua doce'+#13#10+
            '0312403 - Coleta de outros produtos aqu�ticos de �gua doce'+#13#10+
            '0312404 - Atividades de apoio � pesca em �gua doce'+#13#10+
            '0321301 - Cria��o de peixes em �gua salgada e salobra'+#13#10+
            '0321302 - Cria��o de camar�es em �gua salgada e salobra'+#13#10+
            '0321303 - Cria��o de ostras e mexilh�es em �gua salgada e salobra'+#13#10+
            '0321304 - Cria��o de peixes ornamentais em �gua salgada e salobra'+#13#10+
            '0321305 - Atividades de apoio � aquicultura em �gua salgada e salobra'+#13#10+
            '0321399 - Cultivos e semicultivos da aquicultura em �gua salgada e salobra n�o especificados anteriormente'+#13#10+
            '0322101 - Cria��o de peixes em �gua doce'+#13#10+
            '0322102 - Cria��o de camar�es em �gua doce'+#13#10+
            '0322103 - Cria��o de ostras e mexilh�es em �gua doce'+#13#10+
            '0322104 - Cria��o de peixes ornamentais em �gua doce'+#13#10+
            '0322105 - Ranicultura'+#13#10+
            '0322106 - Cria��o de jacar�'+#13#10+
            '0322107 - Atividades de apoio � aquicultura em �gua doce'+#13#10+
            '0322199 - Cultivos e semicultivos da aquicultura em �gua doce n�o especificados anteriormente'+#13#10+
            '0500301 - Extra��o de carv�o mineral'+#13#10+
            '0500302 - Beneficiamento de carv�o mineral'+#13#10+
            '0600001 - Extra��o de petr�leo e g�s natural'+#13#10+
            '0600002 - Extra��o e beneficiamento de xisto'+#13#10+
            '0600003 - Extra��o e beneficiamento de areias betuminosas'+#13#10+
            '0710301 - Extra��o de min�rio de ferro'+#13#10+
            '0710302 - Pelotiza��o, sinteriza��o e outros beneficiamentos de min�rio de ferro'+#13#10+
            '0721901 - Extra��o de min�rio de alum�nio'+#13#10+
            '0721902 - Beneficiamento de min�rio de alum�nio'+#13#10+
            '0722701 - Extra��o de min�rio de estanho'+#13#10+
            '0722702 - Beneficiamento de min�rio de estanho'+#13#10+
            '0723501 - Extra��o de min�rio de mangan�s'+#13#10+
            '0723502 - Beneficiamento de min�rio de mangan�s'+#13#10+
            '0724301 - Extra��o de min�rio de metais preciosos'+#13#10+
            '0724302 - Beneficiamento de min�rio de metais preciosos'+#13#10+
            '0725100 - Extra��o de minerais radioativos'+#13#10+
            '0729401 - Extra��o de min�rios de ni�bio e tit�nio'+#13#10+
            '0729402 - Extra��o de min�rio de tungst�nio'+#13#10+
            '0729403 - Extra��o de min�rio de n�quel'+#13#10+
            '0729404 - Extra��o de min�rios de cobre, chumbo, zinco e outros minerais met�licos n�o ferrosos n�o especificados anteriormente'+#13#10+
            '0729405 - Beneficiamento de min�rios de cobre, chumbo, zinco e outros minerais met�licos n�o ferrosos n�o especificados anteriormente'+#13#10+
            '0810001 - Extra��o de ard�sia e beneficiamento associado'+#13#10+
            '0810002 - Extra��o de granito e beneficiamento associado'+#13#10+
            '0810003 - Extra��o de m�rmore e beneficiamento associado'+#13#10+
            '0810004 - Extra��o de calc�rio e dolomita e beneficiamento associado'+#13#10+
            '0810005 - Extra��o de gesso e caulim'+#13#10+
            '0810006 - Extra��o de areia, cascalho ou pedregulho e beneficiamento associado'+#13#10+
            '0810007 - Extra��o de argila e beneficiamento associado'+#13#10+
            '0810008 - Extra��o de saibro e beneficiamento associado'+#13#10+
            '0810009 - Extra��o de basalto e beneficiamento associado'+#13#10+
            '0810010 - Beneficiamento de gesso e caulim associado � extra��o'+#13#10+
            '0810099 - Extra��o e britamento de pedras e outros materiais para constru��o e beneficiamento associado'+#13#10+
            '0891600 - Extra��o de minerais para fabrica��o de adubos, fertilizantes e outros produtos qu�micos'+#13#10+
            '0892401 - Extra��o de sal marinho'+#13#10+
            '0892402 - Extra��o de sal-gema'+#13#10+
            '0892403 - Refino e outros tratamentos do sal'+#13#10+
            '0893200 - Extra��o de gemas (pedras preciosas e semipreciosas)'+#13#10+
            '0899101 - Extra��o de grafita'+#13#10+
            '0899102 - Extra��o de quartzo'+#13#10+
            '0899103 - Extra��o de amianto'+#13#10+
            '0899199 - Extra��o de outros minerais n�o met�licos n�o especificados anteriormente'+#13#10+
            '0910600 - Atividades de apoio � extra��o de petr�leo e g�s natural'+#13#10+
            '0990401 - Atividades de apoio � extra��o de min�rio de ferro'+#13#10+
            '0990402 - Atividades de apoio � extra��o de minerais met�licos n�o ferrosos'+#13#10+
            '0990403 - Atividades de apoio � extra��o de minerais n�o met�licos'+#13#10+
            '1011201 - Frigor�fico - abate de bovinos'+#13#10+
            '1011202 - Frigor�fico - abate de equinos'+#13#10+
            '1011203 - Frigor�fico - abate de ovinos e caprinos'+#13#10+
            '1011204 - Frigor�fico - abate de bufalinos'+#13#10+
            '1011205 - Matadouro - abate de reses sob contrato, exceto abate de su�nos'+#13#10+
            '1012101 - Abate de aves'+#13#10+
            '1012102 - Abate de pequenos animais'+#13#10+
            '1012103 - Frigor�fico - abate de su�nos'+#13#10+
            '1012104 - Matadouro - abate de su�nos sob contrato'+#13#10+
            '1013901 - Fabrica��o de produtos de carne'+#13#10+
            '1013902 - Prepara��o de subprodutos do abate'+#13#10+
            '1020101 - Preserva��o de peixes, crust�ceos e moluscos'+#13#10+
            '1020102 - Fabrica��o de conservas de peixes, crust�ceos e moluscos'+#13#10+
            '1031700 - Fabrica��o de conservas de frutas'+#13#10+
            '1032501 - Fabrica��o de conservas de palmito'+#13#10+
            '1032599 - Fabrica��o de conservas de legumes e outros vegetais, exceto palmito'+#13#10+
            '1033301 - Fabrica��o de sucos concentrados de frutas, hortali�as e legumes'+#13#10+
            '1033302 - Fabrica��o de sucos de frutas, hortali�as e legumes, exceto concentrados'+#13#10+
            '1041400 - Fabrica��o de �leos vegetais em bruto, exceto �leo de milho'+#13#10+
            '1042200 - Fabrica��o de �leos vegetais refinados, exceto �leo de milho'+#13#10+
            '1043100 - Fabrica��o de margarina e outras gorduras vegetais e de �leos n�o comest�veis de animais'+#13#10+
            '1051100 - Prepara��o do leite'+#13#10+
            '1052000 - Fabrica��o de latic�nios'+#13#10+
            '1053800 - Fabrica��o de sorvetes e outros gelados comest�veis'+#13#10+
            '1061901 - Beneficiamento de arroz'+#13#10+
            '1061902 - Fabrica��o de produtos do arroz'+#13#10+
            '1062700 - Moagem de trigo e fabrica��o de derivados'+#13#10+
            '1063500 - Fabrica��o de farinha de mandioca e derivados'+#13#10+
            '1064300 - Fabrica��o de farinha de milho e derivados, exceto �leos de milho'+#13#10+
            '1065101 - Fabrica��o de amidos e f�culas de vegetais'+#13#10+
            '1065102 - Fabrica��o de �leo de milho em bruto'+#13#10+
            '1065103 - Fabrica��o de �leo de milho refinado'+#13#10+
            '1066000 - Fabrica��o de alimentos para animais'+#13#10+
            '1069400 - Moagem e fabrica��o de produtos de origem vegetal n�o especificados anteriormente'+#13#10+
            '1071600 - Fabrica��o de a��car em bruto'+#13#10+
            '1072401 - Fabrica��o de a��car de cana refinado'+#13#10+
            '1072402 - Fabrica��o de a��car de cereais (dextrose) e de beterraba'+#13#10+
            '1081301 - Beneficiamento de caf�'+#13#10+
            '1081302 - Torrefa��o e moagem de caf�'+#13#10+
            '1082100 - Fabrica��o de produtos � base de caf�'+#13#10+
            '1091101 - Fabrica��o de produtos de panifica��o industrial'+#13#10+
            '1091102 - Fabrica��o de produtos de padaria e confeitaria com predomin�ncia de produ��o pr�pria'+#13#10+
            '1092900 - Fabrica��o de biscoitos e bolachas'+#13#10+
            '1093701 - Fabrica��o de produtos derivados do cacau e de chocolates'+#13#10+
            '1093702 - Fabrica��o de frutas cristalizadas, balas e semelhantes'+#13#10+
            '1094500 - Fabrica��o de massas aliment�cias'+#13#10+
            '1095300 - Fabrica��o de especiarias, molhos, temperos e condimentos'+#13#10+
            '1096100 - Fabrica��o de alimentos e pratos prontos'+#13#10+
            '1099601 - Fabrica��o de vinagres'+#13#10+
            '1099602 - Fabrica��o de p�s-aliment�cios'+#13#10+
            '1099603 - Fabrica��o de fermentos e leveduras'+#13#10+
            '1099604 - Fabrica��o de gelo comum'+#13#10+
            '1099605 - Fabrica��o de produtos para infus�o (ch�, mate, etc.)'+#13#10+
            '1099606 - Fabrica��o de ado�antes naturais e artificiais'+#13#10+
            '1099607 - Fabrica��o de alimentos diet�ticos e complementos alimentares'+#13#10+
            '1099699 - Fabrica��o de outros produtos aliment�cios n�o especificados anteriormente'+#13#10+
            '1111901 - Fabrica��o de aguardente de cana-de-a��car'+#13#10+
            '1111902 - Fabrica��o de outras aguardentes e bebidas destiladas'+#13#10+
            '1112700 - Fabrica��o de vinho'+#13#10+
            '1113501 - Fabrica��o de malte, inclusive malte u�sque'+#13#10+
            '1113502 - Fabrica��o de cervejas e chopes'+#13#10+
            '1121600 - Fabrica��o de �guas envasadas'+#13#10+
            '1122401 - Fabrica��o de refrigerantes'+#13#10+
            '1122402 - Fabrica��o de ch� mate e outros ch�s prontos para consumo'+#13#10+
            '1122403 - Fabrica��o de refrescos, xaropes e p�s para refrescos, exceto refrescos de frutas'+#13#10+
            '1122404 - Fabrica��o de bebidas isot�nicas'+#13#10+
            '1122499 - Fabrica��o de outras bebidas n�o alco�licas n�o especificadas anteriormente'+#13#10+
            '1210700 - Processamento industrial do fumo'+#13#10+
            '1220401 - Fabrica��o de cigarros'+#13#10+
            '1220402 - Fabrica��o de cigarrilhas e charutos'+#13#10+
            '1220403 - Fabrica��o de filtros para cigarros'+#13#10+
            '1220499 - Fabrica��o de outros produtos do fumo, exceto cigarros, cigarrilhas e charutos'+#13#10+
            '1311100 - Prepara��o e fia��o de fibras de algod�o'+#13#10+
            '1312000 - Prepara��o e fia��o de fibras t�xteis naturais, exceto algod�o'+#13#10+
            '1313800 - Fia��o de fibras artificiais e sint�ticas'+#13#10+
            '1314600 - Fabrica��o de linhas para costurar e bordar'+#13#10+
            '1321900 - Tecelagem de fios de algod�o'+#13#10+
            '1322700 - Tecelagem de fios de fibras t�xteis naturais, exceto algod�o'+#13#10+
            '1323500 - Tecelagem de fios de fibras artificiais e sint�ticas'+#13#10+
            '1330800 - Fabrica��o de tecidos de malha'+#13#10+
            '1340501 - Estamparia e texturiza��o em fios, tecidos, artefatos t�xteis e pe�as do vestu�rio'+#13#10+
            '1340502 - Alvejamento, tingimento e tor��o em fios, tecidos, artefatos t�xteis e pe�as do vestu�rio'+#13#10+
            '1340599 - Outros servi�os de acabamento em fios, tecidos, artefatos t�xteis e pe�as do vestu�rio'+#13#10+
            '1351100 - Fabrica��o de artefatos t�xteis para uso dom�stico'+#13#10+
            '1352900 - Fabrica��o de artefatos de tape�aria'+#13#10+
            '1353700 - Fabrica��o de artefatos de cordoaria'+#13#10+
            '1354500 - Fabrica��o de tecidos especiais, inclusive artefatos'+#13#10+
            '1359600 - Fabrica��o de outros produtos t�xteis n�o especificados anteriormente'+#13#10+
            '1411801 - Confec��o de roupas �ntimas'+#13#10+
            '1411802 - Fac��o de roupas �ntimas'+#13#10+
            '1412601 - Confec��o de pe�as do vestu�rio, exceto roupas �ntimas e as confeccionadas sob medida'+#13#10+
            '1412602 - Confec��o, sob medida, de pe�as do vestu�rio, exceto roupas �ntimas'+#13#10+
            '1412603 - Fac��o de pe�as do vestu�rio, exceto roupas �ntimas'+#13#10+
            '1413401 - Confec��o de roupas profissionais, exceto sob medida'+#13#10+
            '1413402 - Confec��o, sob medida, de roupas profissionais'+#13#10+
            '1413403 - Fac��o de roupas profissionais'+#13#10+
            '1414200 - Fabrica��o de acess�rios do vestu�rio, exceto para seguran�a e prote��o'+#13#10+
            '1421500 - Fabrica��o de meias'+#13#10+
            '1422300 - Fabrica��o de artigos do vestu�rio, produzidos em malharias e tricotagens, exceto meias'+#13#10+
            '1510600 - Curtimento e outras prepara��es de couro'+#13#10+
            '1521100 - Fabrica��o de artigos para viagem, bolsas e semelhantes de qualquer material'+#13#10+
            '1529700 - Fabrica��o de artefatos de couro n�o especificados anteriormente'+#13#10+
            '1531901 - Fabrica��o de cal�ados de couro'+#13#10+
            '1531902 - Acabamento de cal�ados de couro sob contrato'+#13#10+
            '1532700 - Fabrica��o de t�nis de qualquer material'+#13#10+
            '1533500 - Fabrica��o de cal�ados de material sint�tico'+#13#10+
            '1539400 - Fabrica��o de cal�ados de materiais n�o especificados anteriormente'+#13#10+
            '1540800 - Fabrica��o de partes para cal�ados, de qualquer material'+#13#10+
            '1610203 - Serrarias com desdobramento de madeira em bruto'+#13#10+
            '1610204 - Serrarias sem desdobramento de madeira em bruto - Resseragem'+#13#10+
            '1610205 - Servi�o de tratamento de madeira realizado sob contrato'+#13#10+
            '1621800 - Fabrica��o de madeira laminada e de chapas de madeira compensada, prensada e aglomerada'+#13#10+
            '1622601 - Fabrica��o de casas de madeira pr�-fabricadas'+#13#10+
            '1622602 - Fabrica��o de esquadrias de madeira e de pe�as de madeira para instala��es industriais e comerciais'+#13#10+
            '1622699 - Fabrica��o de outros artigos de carpintaria para constru��o'+#13#10+
            '1623400 - Fabrica��o de artefatos de tanoaria e de embalagens de madeira'+#13#10+
            '1629301 - Fabrica��o de artefatos diversos de madeira, exceto m�veis'+#13#10+
            '1629302 - Fabrica��o de artefatos diversos de corti�a, bambu, palha, vime e outros materiais tran�ados, exceto m�veis'+#13#10+
            '1710900 - Fabrica��o de celulose e outras pastas para a fabrica��o de papel'+#13#10+
            '1721400 - Fabrica��o de papel'+#13#10+
            '1722200 - Fabrica��o de cartolina e papel-cart�o'+#13#10+
            '1731100 - Fabrica��o de embalagens de papel'+#13#10+
            '1732000 - Fabrica��o de embalagens de cartolina e papel-cart�o'+#13#10+
            '1733800 - Fabrica��o de chapas e de embalagens de papel�o ondulado'+#13#10+
            '1741901 - Fabrica��o de formul�rios cont�nuos'+#13#10+
            '1741902 - Fabrica��o de produtos de papel, cartolina, papel-cart�o e papel�o ondulado para uso comercial e de escrit�rio'+#13#10+
            '1742701 - Fabrica��o de fraldas descart�veis'+#13#10+
            '1742702 - Fabrica��o de absorventes higi�nicos'+#13#10+
            '1742799 - Fabrica��o de produtos de papel para uso dom�stico e higi�nico-sanit�rio n�o especificados anteriormente'+#13#10+
            '1749400 - Fabrica��o de produtos de pastas celul�sicas, papel, cartolina, papel-cart�o e papel�o ondulado n�o especificados anteriormente'+#13#10+
            '1811301 - Impress�o de jornais'+#13#10+
            '1811302 - Impress�o de livros, revistas e outras publica��es peri�dicas'+#13#10+
            '1812100 - Impress�o de material de seguran�a'+#13#10+
            '1813001 - Impress�o de material para uso publicit�rio'+#13#10+
            '1813099 - Impress�o de material para outros usos'+#13#10+
            '1821100 - Servi�os de pr�-impress�o'+#13#10+
            '1822901 - Servi�os de encaderna��o e plastifica��o'+#13#10+
            '1822999 - Servi�os de acabamentos gr�ficos, exceto encaderna��o e plastifica��o'+#13#10+
            '1830001 - Reprodu��o de som em qualquer suporte'+#13#10+
            '1830002 - Reprodu��o de v�deo em qualquer suporte'+#13#10+
            '1830003 - Reprodu��o de software em qualquer suporte'+#13#10+
            '1910100 - Coquerias'+#13#10+
            '1921700 - Fabrica��o de produtos do refino de petr�leo'+#13#10+
            '1922501 - Formula��o de combust�veis'+#13#10+
            '1922502 - Rerrefino de �leos lubrificantes'+#13#10+
            '1922599 - Fabrica��o de outros produtos derivados do petr�leo, exceto produtos do refino'+#13#10+
            '1931400 - Fabrica��o de �lcool'+#13#10+
            '1932200 - Fabrica��o de biocombust�veis, exceto �lcool'+#13#10+
            '2011800 - Fabrica��o de cloro e �lcalis'+#13#10+
            '2012600 - Fabrica��o de intermedi�rios para fertilizantes'+#13#10+
            '2013401 - Fabrica��o de adubos e fertilizantes organo-minerais'+#13#10+
            '2013402 - Fabrica��o de adubos e fertilizantes, exceto organo-minerais'+#13#10+
            '2014200 - Fabrica��o de gases industriais'+#13#10+
            '2019301 - Elabora��o de combust�veis nucleares'+#13#10+
            '2019399 - Fabrica��o de outros produtos qu�micos inorg�nicos n�o especificados anteriormente'+#13#10+
            '2021500 - Fabrica��o de produtos petroqu�micos b�sicos'+#13#10+
            '2022300 - Fabrica��o de intermedi�rios para plastificantes, resinas e fibras'+#13#10+
            '2029100 - Fabrica��o de produtos qu�micos org�nicos n�o especificados anteriormente'+#13#10+
            '2031200 - Fabrica��o de resinas termopl�sticas'+#13#10+
            '2032100 - Fabrica��o de resinas termofixas'+#13#10+
            '2033900 - Fabrica��o de elast�meros'+#13#10+
            '2040100 - Fabrica��o de fibras artificiais e sint�ticas'+#13#10+
            '2051700 - Fabrica��o de defensivos agr�colas'+#13#10+
            '2052500 - Fabrica��o de desinfestantes domissanit�rios'+#13#10+
            '2061400 - Fabrica��o de sab�es e detergentes sint�ticos'+#13#10+
            '2062200 - Fabrica��o de produtos de limpeza e polimento'+#13#10+
            '2063100 - Fabrica��o de cosm�ticos, produtos de perfumaria e de higiene pessoal'+#13#10+
            '2071100 - Fabrica��o de tintas, vernizes, esmaltes e lacas'+#13#10+
            '2072000 - Fabrica��o de tintas de impress�o'+#13#10+
            '2073800 - Fabrica��o de impermeabilizantes, solventes e produtos afins'+#13#10+
            '2091600 - Fabrica��o de adesivos e selantes'+#13#10+
            '2092401 - Fabrica��o de p�lvoras, explosivos e detonantes'+#13#10+
            '2092402 - Fabrica��o de artigos pirot�cnicos'+#13#10+
            '2092403 - Fabrica��o de f�sforos de seguran�a'+#13#10+
            '2093200 - Fabrica��o de aditivos de uso industrial'+#13#10+
            '2094100 - Fabrica��o de catalisadores'+#13#10+
            '2099101 - Fabrica��o de chapas, filmes, pap�is e outros materiais e produtos qu�micos para fotografia'+#13#10+
            '2099199 - Fabrica��o de outros produtos qu�micos n�o especificados anteriormente'+#13#10+
            '2110600 - Fabrica��o de produtos farmoqu�micos'+#13#10+
            '2121101 - Fabrica��o de medicamentos alop�ticos para uso humano'+#13#10+
            '2121102 - Fabrica��o de medicamentos homeop�ticos para uso humano'+#13#10+
            '2121103 - Fabrica��o de medicamentos fitoter�picos para uso humano'+#13#10+
            '2122000 - Fabrica��o de medicamentos para uso veterin�rio'+#13#10+
            '2123800 - Fabrica��o de prepara��es farmac�uticas'+#13#10+
            '2211100 - Fabrica��o de pneum�ticos e de c�maras-de-ar'+#13#10+
            '2212900 - Reforma de pneum�ticos usados'+#13#10+
            '2219600 - Fabrica��o de artefatos de borracha n�o especificados anteriormente'+#13#10+
            '2221800 - Fabrica��o de laminados planos e tubulares de material pl�stico'+#13#10+
            '2222600 - Fabrica��o de embalagens de material pl�stico'+#13#10+
            '2223400 - Fabrica��o de tubos e acess�rios de material pl�stico para uso na constru��o'+#13#10+
            '2229301 - Fabrica��o de artefatos de material pl�stico para uso pessoal e dom�stico'+#13#10+
            '2229302 - Fabrica��o de artefatos de material pl�stico para usos industriais'+#13#10+
            '2229303 - Fabrica��o de artefatos de material pl�stico para uso na constru��o, exceto tubos e acess�rios'+#13#10+
            '2229399 - Fabrica��o de artefatos de material pl�stico para outros usos n�o especificados anteriormente'+#13#10+
            '2311700 - Fabrica��o de vidro plano e de seguran�a'+#13#10+
            '2312500 - Fabrica��o de embalagens de vidro'+#13#10+
            '2319200 - Fabrica��o de artigos de vidro'+#13#10+
            '2320600 - Fabrica��o de cimento'+#13#10+
            '2330301 - Fabrica��o de estruturas pr�-moldadas de concreto armado, em s�rie e sob encomenda'+#13#10+
            '2330302 - Fabrica��o de artefatos de cimento para uso na constru��o'+#13#10+
            '2330303 - Fabrica��o de artefatos de fibrocimento para uso na constru��o'+#13#10+
            '2330304 - Fabrica��o de casas pr�-moldadas de concreto'+#13#10+
            '2330305 - Prepara��o de massa de concreto e argamassa para constru��o'+#13#10+
            '2330399 - Fabrica��o de outros artefatos e produtos de concreto, cimento, fibrocimento, gesso e materiais semelhantes'+#13#10+
            '2341900 - Fabrica��o de produtos cer�micos refrat�rios'+#13#10+
            '2342701 - Fabrica��o de azulejos e pisos'+#13#10+
            '2342702 - Fabrica��o de artefatos de cer�mica e barro cozido para uso na constru��o, exceto azulejos e pisos'+#13#10+
            '2349401 - Fabrica��o de material sanit�rio de cer�mica'+#13#10+
            '2349499 - Fabrica��o de produtos cer�micos n�o refrat�rios n�o especificados anteriormente'+#13#10+
            '2391501 - Britamento de pedras, exceto associado � extra��o'+#13#10+
            '2391502 - Aparelhamento de pedras para constru��o, exceto associado � extra��o'+#13#10+
            '2391503 - Aparelhamento de placas e execu��o de trabalhos em m�rmore, granito, ard�sia e outras pedras'+#13#10+
            '2392300 - Fabrica��o de cal e gesso'+#13#10+
            '2399101 - Decora��o, lapida��o, grava��o, vitrifica��o e outros trabalhos em cer�mica, lou�a, vidro e cristal'+#13#10+
            '2399102 - Fabrica��o de abrasivos'+#13#10+
            '2399199 - Fabrica��o de outros produtos de minerais n�o met�licos n�o especificados anteriormente'+#13#10+
            '2411300 - Produ��o de ferro-gusa'+#13#10+
            '2412100 - Produ��o de ferroligas'+#13#10+
            '2421100 - Produ��o de semiacabados de a�o'+#13#10+
            '2422901 - Produ��o de laminados planos de a�o ao carbono, revestidos ou n�o'+#13#10+
            '2422902 - Produ��o de laminados planos de a�os especiais'+#13#10+
            '2423701 - Produ��o de tubos de a�o sem costura'+#13#10+
            '2423702 - Produ��o de laminados longos de a�o, exceto tubos'+#13#10+
            '2424501 - Produ��o de arames de a�o'+#13#10+
            '2424502 - Produ��o de relaminados, trefilados e perfilados de a�o, exceto arames'+#13#10+
            '2431800 - Produ��o de tubos de a�o com costura'+#13#10+
            '2439300 - Produ��o de outros tubos de ferro e a�o'+#13#10+
            '2441501 - Produ��o de alum�nio e suas ligas em formas prim�rias'+#13#10+
            '2441502 - Produ��o de laminados de alum�nio'+#13#10+
            '2442300 - Metalurgia dos metais preciosos'+#13#10+
            '2443100 - Metalurgia do cobre'+#13#10+
            '2449101 - Produ��o de zinco em formas prim�rias'+#13#10+
            '2449102 - Produ��o de laminados de zinco'+#13#10+
            '2449103 - Fabrica��o de �nodos para galvanoplastia'+#13#10+
            '2449199 - Metalurgia de outros metais n�o ferrosos e suas ligas n�o especificados anteriormente'+#13#10+
            '2451200 - Fundi��o de ferro e a�o'+#13#10+
            '2452100 - Fundi��o de metais n�o ferrosos e suas ligas'+#13#10+
            '2511000 - Fabrica��o de estruturas met�licas'+#13#10+
            '2512800 - Fabrica��o de esquadrias de metal'+#13#10+
            '2513600 - Fabrica��o de obras de caldeiraria pesada'+#13#10+
            '2521700 - Fabrica��o de tanques, reservat�rios met�licos e caldeiras para aquecimento central'+#13#10+
            '2522500 - Fabrica��o de caldeiras geradoras de vapor, exceto para aquecimento central e para ve�culos'+#13#10+
            '2531401 - Produ��o de forjados de a�o'+#13#10+
            '2531402 - Produ��o de forjados de metais n�o ferrosos e suas ligas'+#13#10+
            '2532201 - Produ��o de artefatos estampados de metal'+#13#10+
            '2532202 - Metalurgia do p�'+#13#10+
            '2539001 - Servi�os de usinagem, torneiria e solda'+#13#10+
            '2539002 - Servi�os de tratamento e revestimento em metais'+#13#10+
            '2541100 - Fabrica��o de artigos de cutelaria'+#13#10+
            '2542000 - Fabrica��o de artigos de serralheria, exceto esquadrias'+#13#10+
            '2543800 - Fabrica��o de ferramentas'+#13#10+
            '2550101 - Fabrica��o de equipamento b�lico pesado, exceto ve�culos militares de combate'+#13#10+
            '2550102 - Fabrica��o de armas de fogo, outras armas e muni��es'+#13#10+
            '2591800 - Fabrica��o de embalagens met�licas'+#13#10+
            '2592601 - Fabrica��o de produtos de trefilados de metal padronizados'+#13#10+
            '2592602 - Fabrica��o de produtos de trefilados de metal, exceto padronizados'+#13#10+
            '2593400 - Fabrica��o de artigos de metal para uso dom�stico e pessoal'+#13#10+
            '2599301 - Servi�os de confec��o de arma��es met�licas para a constru��o'+#13#10+
            '2599302 - Servi�o de corte e dobra de metais'+#13#10+
            '2599399 - Fabrica��o de outros produtos de metal n�o especificados anteriormente'+#13#10+
            '2610800 - Fabrica��o de componentes eletr�nicos'+#13#10+
            '2621300 - Fabrica��o de equipamentos de inform�tica'+#13#10+
            '2622100 - Fabrica��o de perif�ricos para equipamentos de inform�tica'+#13#10+
            '2631100 - Fabrica��o de equipamentos transmissores de comunica��o, pe�as e acess�rios'+#13#10+
            '2632900 - Fabrica��o de aparelhos telef�nicos e de outros equipamentos de comunica��o, pe�as e acess�rios'+#13#10+
            '2640000 - Fabrica��o de aparelhos de recep��o, reprodu��o, grava��o e amplifica��o de �udio e v�deo'+#13#10+
            '2651500 - Fabrica��o de aparelhos e equipamentos de medida, teste e controle'+#13#10+
            '2652300 - Fabrica��o de cron�metros e rel�gios'+#13#10+
            '2660400 - Fabrica��o de aparelhos eletrom�dicos e eletroterap�uticos e equipamentos de irradia��o'+#13#10+
            '2670101 - Fabrica��o de equipamentos e instrumentos �pticos, pe�as e acess�rios'+#13#10+
            '2670102 - Fabrica��o de aparelhos fotogr�ficos e cinematogr�ficos, pe�as e acess�rios'+#13#10+
            '2680900 - Fabrica��o de m�dias virgens, magn�ticas e �pticas'+#13#10+
            '2710401 - Fabrica��o de geradores de corrente cont�nua e alternada, pe�as e acess�rios'+#13#10+
            '2710402 - Fabrica��o de transformadores, indutores, conversores, sincronizadores e semelhantes, pe�as e acess�rios'+#13#10+
            '2710403 - Fabrica��o de motores el�tricos, pe�as e acess�rios'+#13#10+
            '2721000 - Fabrica��o de pilhas, baterias e acumuladores el�tricos, exceto para ve�culos automotores'+#13#10+
            '2722801 - Fabrica��o de baterias e acumuladores para ve�culos automotores'+#13#10+
            '2722802 - Recondicionamento de baterias e acumuladores para ve�culos automotores'+#13#10+
            '2731700 - Fabrica��o de aparelhos e equipamentos para distribui��o e controle de energia el�trica'+#13#10+
            '2732500 - Fabrica��o de material el�trico para instala��es em circuito de consumo'+#13#10+
            '2733300 - Fabrica��o de fios, cabos e condutores el�tricos isolados'+#13#10+
            '2740601 - Fabrica��o de l�mpadas'+#13#10+
            '2740602 - Fabrica��o de lumin�rias e outros equipamentos de ilumina��o'+#13#10+
            '2751100 - Fabrica��o de fog�es, refrigeradores e m�quinas de lavar e secar para uso dom�stico, pe�as e acess�rios'+#13#10+
            '2759701 - Fabrica��o de aparelhos el�tricos de uso pessoal, pe�as e acess�rios'+#13#10+
            '2759799 - Fabrica��o de outros aparelhos eletrodom�sticos n�o especificados anteriormente, pe�as e acess�rios'+#13#10+
            '2790201 - Fabrica��o de eletrodos, contatos e outros artigos de carv�o e grafita para uso el�trico, eletro�m�s e isoladores'+#13#10+
            '2790202 - Fabrica��o de equipamentos para sinaliza��o e alarme'+#13#10+
            '2790299 - Fabrica��o de outros equipamentos e aparelhos el�tricos n�o especificados anteriormente'+#13#10+
            '2811900 - Fabrica��o de motores e turbinas, pe�as e acess�rios, exceto para avi�es e ve�culos rodovi�rios'+#13#10+
            '2812700 - Fabrica��o de equipamentos hidr�ulicos e pneum�ticos, pe�as e acess�rios, exceto v�lvulas'+#13#10+
            '2813500 - Fabrica��o de v�lvulas, registros e dispositivos semelhantes, pe�as e acess�rios'+#13#10+
            '2814301 - Fabrica��o de compressores para uso industrial, pe�as e acess�rios'+#13#10+
            '2814302 - Fabrica��o de compressores para uso n�o industrial, pe�as e acess�rios'+#13#10+
            '2815101 - Fabrica��o de rolamentos para fins industriais'+#13#10+
            '2815102 - Fabrica��o de equipamentos de transmiss�o para fins industriais, exceto rolamentos'+#13#10+
            '2821601 - Fabrica��o de fornos industriais, aparelhos e equipamentos n�o el�tricos para instala��es t�rmicas, pe�as e acess�rios'+#13#10+
            '2821602 - Fabrica��o de estufas e fornos el�tricos para fins industriais, pe�as e acess�rios'+#13#10+
            '2822401 - Fabrica��o de m�quinas, equipamentos e aparelhos para transporte e eleva��o de pessoas, pe�as e acess�rios'+#13#10+
            '2822402 - Fabrica��o de m�quinas, equipamentos e aparelhos para transporte e eleva��o de cargas, pe�as e acess�rios'+#13#10+
            '2823200 - Fabrica��o de m�quinas e aparelhos de refrigera��o e ventila��o para uso industrial e comercial, pe�as e acess�rios'+#13#10+
            '2824101 - Fabrica��o de aparelhos e equipamentos de ar condicionado para uso industrial'+#13#10+
            '2824102 - Fabrica��o de aparelhos e equipamentos de ar condicionado para uso n�o industrial'+#13#10+
            '2825900 - Fabrica��o de m�quinas e equipamentos para saneamento b�sico e ambiental, pe�as e acess�rios'+#13#10+
            '2829101 - Fabrica��o de m�quinas de escrever, calcular e outros equipamentos n�o eletr�nicos para escrit�rio, pe�as e acess�rios'+#13#10+
            '2829199 - Fabrica��o de outras m�quinas e equipamentos de uso geral n�o especificados anteriormente, pe�as e acess�rios'+#13#10+
            '2831300 - Fabrica��o de tratores agr�colas, pe�as e acess�rios'+#13#10+
            '2832100 - Fabrica��o de equipamentos para irriga��o agr�cola, pe�as e acess�rios'+#13#10+
            '2833000 - Fabrica��o de m�quinas e equipamentos para a agricultura e pecu�ria, pe�as e acess�rios, exceto para irriga��o'+#13#10+
            '2840200 - Fabrica��o de m�quinas-ferramenta, pe�as e acess�rios'+#13#10+
            '2851800 - Fabrica��o de m�quinas e equipamentos para a prospec��o e extra��o de petr�leo, pe�as e acess�rios'+#13#10+
            '2852600 - Fabrica��o de outras m�quinas e equipamentos para uso na extra��o mineral, pe�as e acess�rios, exceto na extra��o de petr�leo'+#13#10+
            '2853400 - Fabrica��o de tratores, pe�as e acess�rios, exceto agr�colas'+#13#10+
            '2854200 - Fabrica��o de m�quinas e equipamentos para terraplenagem, pavimenta��o e constru��o, pe�as e acess�rios, exceto tratores'+#13#10+
            '2861500 - Fabrica��o de m�quinas para a ind�stria metal�rgica, pe�as e acess�rios, exceto m�quinas-ferramenta'+#13#10+
            '2862300 - Fabrica��o de m�quinas e equipamentos para as ind�strias de alimentos, bebidas e fumo, pe�as e acess�rios'+#13#10+
            '2863100 - Fabrica��o de m�quinas e equipamentos para a ind�stria t�xtil, pe�as e acess�rios'+#13#10+
            '2864000 - Fabrica��o de m�quinas e equipamentos para as ind�strias do vestu�rio, do couro e de cal�ados, pe�as e acess�rios'+#13#10+
            '2865800 - Fabrica��o de m�quinas e equipamentos para as ind�strias de celulose, papel e papel�o e artefatos, pe�as e acess�rios'+#13#10+
            '2866600 - Fabrica��o de m�quinas e equipamentos para a ind�stria do pl�stico, pe�as e acess�rios'+#13#10+
            '2869100 - Fabrica��o de m�quinas e equipamentos para uso industrial espec�fico n�o especificados anteriormente, pe�as e acess�rios'+#13#10+
            '2910701 - Fabrica��o de autom�veis, camionetas e utilit�rios'+#13#10+
            '2910702 - Fabrica��o de chassis com motor para autom�veis, camionetas e utilit�rios'+#13#10+
            '2910703 - Fabrica��o de motores para autom�veis, camionetas e utilit�rios'+#13#10+
            '2920401 - Fabrica��o de caminh�es e �nibus'+#13#10+
            '2920402 - Fabrica��o de motores para caminh�es e �nibus'+#13#10+
            '2930101 - Fabrica��o de cabines, carrocerias e reboques para caminh�es'+#13#10+
            '2930102 - Fabrica��o de carrocerias para �nibus'+#13#10+
            '2930103 - Fabrica��o de cabines, carrocerias e reboques para outros ve�culos automotores, exceto caminh�es e �nibus'+#13#10+
            '2941700 - Fabrica��o de pe�as e acess�rios para o sistema motor de ve�culos automotores'+#13#10+
            '2942500 - Fabrica��o de pe�as e acess�rios para os sistemas de marcha e transmiss�o de ve�culos automotores'+#13#10+
            '2943300 - Fabrica��o de pe�as e acess�rios para o sistema de freios de ve�culos automotores'+#13#10+
            '2944100 - Fabrica��o de pe�as e acess�rios para o sistema de dire��o e suspens�o de ve�culos automotores'+#13#10+
            '2945000 - Fabrica��o de material el�trico e eletr�nico para ve�culos automotores, exceto baterias'+#13#10+
            '2949201 - Fabrica��o de bancos e estofados para ve�culos automotores'+#13#10+
            '2949299 - Fabrica��o de outras pe�as e acess�rios para ve�culos automotores n�o especificadas anteriormente'+#13#10+
            '2950600 - Recondicionamento e recupera��o de motores para ve�culos automotores'+#13#10+
            '3011301 - Constru��o de embarca��es de grande porte'+#13#10+
            '3011302 - Constru��o de embarca��es para uso comercial e para usos especiais, exceto de grande porte'+#13#10+
            '3012100 - Constru��o de embarca��es para esporte e lazer'+#13#10+
            '3031800 - Fabrica��o de locomotivas, vag�es e outros materiais rodantes'+#13#10+
            '3032600 - Fabrica��o de pe�as e acess�rios para ve�culos ferrovi�rios'+#13#10+
            '3041500 - Fabrica��o de aeronaves'+#13#10+
            '3042300 - Fabrica��o de turbinas, motores e outros componentes e pe�as para aeronaves'+#13#10+
            '3050400 - Fabrica��o de ve�culos militares de combate'+#13#10+
            '3091101 - Fabrica��o de motocicletas'+#13#10+
            '3091102 - Fabrica��o de pe�as e acess�rios para motocicletas'+#13#10+
            '3092000 - Fabrica��o de bicicletas e triciclos n�o motorizados, pe�as e acess�rios'+#13#10+
            '3099700 - Fabrica��o de equipamentos de transporte n�o especificados anteriormente'+#13#10+
            '3101200 - Fabrica��o de m�veis com predomin�ncia de madeira'+#13#10+
            '3102100 - Fabrica��o de m�veis com predomin�ncia de metal'+#13#10+
            '3103900 - Fabrica��o de m�veis de outros materiais, exceto madeira e metal'+#13#10+
            '3104700 - Fabrica��o de colch�es'+#13#10+
            '3211601 - Lapida��o de gemas'+#13#10+
            '3211602 - Fabrica��o de artefatos de joalheria e ourivesaria'+#13#10+
            '3211603 - Cunhagem de moedas e medalhas'+#13#10+
            '3212400 - Fabrica��o de bijuterias e artefatos semelhantes'+#13#10+
            '3220500 - Fabrica��o de instrumentos musicais, pe�as e acess�rios'+#13#10+
            '3230200 - Fabrica��o de artefatos para pesca e esporte'+#13#10+
            '3240001 - Fabrica��o de jogos eletr�nicos'+#13#10+
            '3240002 - Fabrica��o de mesas de bilhar, de sinuca e acess�rios n�o associada � loca��o'+#13#10+
            '3240003 - Fabrica��o de mesas de bilhar, de sinuca e acess�rios associada � loca��o'+#13#10+
            '3240099 - Fabrica��o de outros brinquedos e jogos recreativos n�o especificados anteriormente'+#13#10+
            '3250701 - Fabrica��o de instrumentos n�o eletr�nicos e utens�lios para uso m�dico, cir�rgico, odontol�gico e de laborat�rio'+#13#10+
            '3250702 - Fabrica��o de mobili�rio para uso m�dico, cir�rgico, odontol�gico e de laborat�rio'+#13#10+
            '3250703 - Fabrica��o de aparelhos e utens�lios para corre��o de defeitos f�sicos e aparelhos ortop�dicos em geral sob encomenda'+#13#10+
            '3250704 - Fabrica��o de aparelhos e utens�lios para corre��o de defeitos f�sicos e aparelhos ortop�dicos em geral, exceto sob encomenda'+#13#10+
            '3250705 - Fabrica��o de materiais para medicina e odontologia'+#13#10+
            '3250706 - Servi�os de pr�tese dent�ria'+#13#10+
            '3250707 - Fabrica��o de artigos �pticos'+#13#10+
            '3250709 - Servi�o de laborat�rio �ptico'+#13#10+
            '3291400 - Fabrica��o de escovas, pinc�is e vassouras'+#13#10+
            '3292201 - Fabrica��o de roupas de prote��o e seguran�a e resistentes a fogo'+#13#10+
            '3292202 - Fabrica��o de equipamentos e acess�rios para seguran�a pessoal e profissional'+#13#10+
            '3299001 - Fabrica��o de guarda-chuvas e similares'+#13#10+
            '3299002 - Fabrica��o de canetas, l�pis e outros artigos para escrit�rio'+#13#10+
            '3299003 - Fabrica��o de letras, letreiros e placas de qualquer material, exceto luminosos'+#13#10+
            '3299004 - Fabrica��o de pain�is e letreiros luminosos'+#13#10+
            '3299005 - Fabrica��o de aviamentos para costura'+#13#10+
            '3299006 - Fabrica��o de velas, inclusive decorativas'+#13#10+
            '3299099 - Fabrica��o de produtos diversos n�o especificados anteriormente'+#13#10+
            '3311200 - Manuten��o e repara��o de tanques, reservat�rios met�licos e caldeiras, exceto para ve�culos'+#13#10+
            '3312102 - Manuten��o e repara��o de aparelhos e instrumentos de medida, teste e controle'+#13#10+
            '3312103 - Manuten��o e repara��o de aparelhos eletrom�dicos e eletroterap�uticos e equipamentos de irradia��o'+#13#10+
            '3312104 - Manuten��o e repara��o de equipamentos e instrumentos �pticos'+#13#10+
            '3313901 - Manuten��o e repara��o de geradores, transformadores e motores el�tricos'+#13#10+
            '3313902 - Manuten��o e repara��o de baterias e acumuladores el�tricos, exceto para ve�culos'+#13#10+
            '3313999 - Manuten��o e repara��o de m�quinas, aparelhos e materiais el�tricos n�o especificados anteriormente'+#13#10+
            '3314701 - Manuten��o e repara��o de m�quinas motrizes n�o el�tricas'+#13#10+
            '3314702 - Manuten��o e repara��o de equipamentos hidr�ulicos e pneum�ticos, exceto v�lvulas'+#13#10+
            '3314703 - Manuten��o e repara��o de v�lvulas industriais'+#13#10+
            '3314704 - Manuten��o e repara��o de compressores'+#13#10+
            '3314705 - Manuten��o e repara��o de equipamentos de transmiss�o para fins industriais'+#13#10+
            '3314706 - Manuten��o e repara��o de m�quinas, aparelhos e equipamentos para instala��es t�rmicas'+#13#10+
            '3314707 - Manuten��o e repara��o de m�quinas e aparelhos de refrigera��o e ventila��o para uso industrial e comercial'+#13#10+
            '3314708 - Manuten��o e repara��o de m�quinas, equipamentos e aparelhos para transporte e eleva��o de cargas'+#13#10+
            '3314709 - Manuten��o e repara��o de m�quinas de escrever, calcular e de outros equipamentos n�o eletr�nicos para escrit�rio'+#13#10+
            '3314710 - Manuten��o e repara��o de m�quinas e equipamentos para uso geral n�o especificados anteriormente'+#13#10+
            '3314711 - Manuten��o e repara��o de m�quinas e equipamentos para agricultura e pecu�ria'+#13#10+
            '3314712 - Manuten��o e repara��o de tratores agr�colas'+#13#10+
            '3314713 - Manuten��o e repara��o de m�quinas-ferramenta'+#13#10+
            '3314714 - Manuten��o e repara��o de m�quinas e equipamentos para a prospec��o e extra��o de petr�leo'+#13#10+
            '3314715 - Manuten��o e repara��o de m�quinas e equipamentos para uso na extra��o mineral, exceto na extra��o de petr�leo'+#13#10+
            '3314716 - Manuten��o e repara��o de tratores, exceto agr�colas'+#13#10+
            '3314717 - Manuten��o e repara��o de m�quinas e equipamentos de terraplenagem, pavimenta��o e constru��o, exceto tratores'+#13#10+
            '3314718 - Manuten��o e repara��o de m�quinas para a ind�stria metal�rgica, exceto m�quinas-ferramenta'+#13#10+
            '3314719 - Manuten��o e repara��o de m�quinas e equipamentos para as ind�strias de alimentos, bebidas e fumo'+#13#10+
            '3314720 - Manuten��o e repara��o de m�quinas e equipamentos para a ind�stria t�xtil, do vestu�rio, do couro e cal�ados'+#13#10+
            '3314721 - Manuten��o e repara��o de m�quinas e aparelhos para a ind�stria de celulose, papel e papel�o e artefatos'+#13#10+
            '3314722 - Manuten��o e repara��o de m�quinas e aparelhos para a ind�stria do pl�stico'+#13#10+
            '3314799 - Manuten��o e repara��o de outras m�quinas e equipamentos para usos industriais n�o especificados anteriormente'+#13#10+
            '3315500 - Manuten��o e repara��o de ve�culos ferrovi�rios'+#13#10+
            '3316301 - Manuten��o e repara��o de aeronaves, exceto a manuten��o na pista'+#13#10+
            '3316302 - Manuten��o de aeronaves na pista'+#13#10+
            '3317101 - Manuten��o e repara��o de embarca��es e estruturas flutuantes'+#13#10+
            '3317102 - Manuten��o e repara��o de embarca��es para esporte e lazer'+#13#10+
            '3319800 - Manuten��o e repara��o de equipamentos e produtos n�o especificados anteriormente'+#13#10+
            '3321000 - Instala��o de m�quinas e equipamentos industriais'+#13#10+
            '3329501 - Servi�os de montagem de m�veis de qualquer material'+#13#10+
            '3329599 - Instala��o de outros equipamentos n�o especificados anteriormente'+#13#10+
            '3511501 - Gera��o de energia el�trica'+#13#10+
            '3511502 - Atividades de coordena��o e controle da opera��o da gera��o e transmiss�o de energia el�trica'+#13#10+
            '3512300 - Transmiss�o de energia el�trica'+#13#10+
            '3513100 - Com�rcio atacadista de energia el�trica'+#13#10+
            '3514000 - Distribui��o de energia el�trica'+#13#10+
            '3520401 - Produ��o de g�s; processamento de g�s natural'+#13#10+
            '3520402 - Distribui��o de combust�veis gasosos por redes urbanas'+#13#10+
            '3530100 - Produ��o e distribui��o de vapor, �gua quente e ar condicionado'+#13#10+
            '3600601 - Capta��o, tratamento e distribui��o de �gua'+#13#10+
            '3600602 - Distribui��o de �gua por caminh�es'+#13#10+
            '3701100 - Gest�o de redes de esgoto'+#13#10+
            '3702900 - Atividades relacionadas a esgoto, exceto a gest�o de redes'+#13#10+
            '3811400 - Coleta de res�duos n�o perigosos'+#13#10+
            '3812200 - Coleta de res�duos perigosos'+#13#10+
            '3821100 - Tratamento e disposi��o de res�duos n�o perigosos'+#13#10+
            '3822000 - Tratamento e disposi��o de res�duos perigosos'+#13#10+
            '3831901 - Recupera��o de sucatas de alum�nio'+#13#10+
            '3831999 - Recupera��o de materiais met�licos, exceto alum�nio'+#13#10+
            '3832700 - Recupera��o de materiais pl�sticos'+#13#10+
            '3839401 - Usinas de compostagem'+#13#10+
            '3839499 - Recupera��o de materiais n�o especificados anteriormente'+#13#10+
            '3900500 - Descontamina��o e outros servi�os de gest�o de res�duos'+#13#10+
            '4110700 - Incorpora��o de empreendimentos imobili�rios'+#13#10+
            '4120400 - Constru��o de edif�cios'+#13#10+
            '4211101 - Constru��o de rodovias e ferrovias'+#13#10+
            '4211102 - Pintura para sinaliza��o em pistas rodovi�rias e aeroportos'+#13#10+
            '4212000 - Constru��o de obras de arte especiais'+#13#10+
            '4213800 - Obras de urbaniza��o - ruas, pra�as e cal�adas'+#13#10+
            '4221901 - Constru��o de barragens e represas para gera��o de energia el�trica'+#13#10+
            '4221902 - Constru��o de esta��es e redes de distribui��o de energia el�trica'+#13#10+
            '4221903 - Manuten��o de redes de distribui��o de energia el�trica'+#13#10+
            '4221904 - Constru��o de esta��es e redes de telecomunica��es'+#13#10+
            '4221905 - Manuten��o de esta��es e redes de telecomunica��es'+#13#10+
            '4222701 - Constru��o de redes de abastecimento de �gua, coleta de esgoto e constru��es correlatas, exceto obras de irriga��o'+#13#10+
            '4222702 - Obras de irriga��o'+#13#10+
            '4223500 - Constru��o de redes de transportes por dutos, exceto para �gua e esgoto'+#13#10+
            '4291000 - Obras portu�rias, mar�timas e fluviais'+#13#10+
            '4292801 - Montagem de estruturas met�licas'+#13#10+
            '4292802 - Obras de montagem industrial'+#13#10+
            '4299501 - Constru��o de instala��es esportivas e recreativas'+#13#10+
            '4299599 - Outras obras de engenharia civil n�o especificadas anteriormente'+#13#10+
            '4311801 - Demoli��o de edif�cios e outras estruturas'+#13#10+
            '4311802 - Prepara��o de canteiro e limpeza de terreno'+#13#10+
            '4312600 - Perfura��es e sondagens'+#13#10+
            '4313400 - Obras de terraplenagem'+#13#10+
            '4319300 - Servi�os de prepara��o do terreno n�o especificados anteriormente'+#13#10+
            '4321500 - Instala��o e manuten��o el�trica'+#13#10+
            '4322301 - Instala��es hidr�ulicas, sanit�rias e de g�s'+#13#10+
            '4322302 - Instala��o e manuten��o de sistemas centrais de ar condicionado, de ventila��o e refrigera��o'+#13#10+
            '4322303 - Instala��es de sistema de preven��o contra inc�ndio'+#13#10+
            '4329101 - Instala��o de pain�is publicit�rios'+#13#10+
            '4329102 - Instala��o de equipamentos para orienta��o � navega��o mar�tima, fluvial e lacustre'+#13#10+
            '4329103 - Instala��o, manuten��o e repara��o de elevadores, escadas e esteiras rolantes'+#13#10+
            '4329104 - Montagem e instala��o de sistemas e equipamentos de ilumina��o e sinaliza��o em vias p�blicas, portos e aeroportos'+#13#10+
            '4329105 - Tratamentos t�rmicos, ac�sticos ou de vibra��o'+#13#10+
            '4329199 - Outras obras de instala��es em constru��es n�o especificadas anteriormente'+#13#10+
            '4330401 - Impermeabiliza��o em obras de engenharia civil'+#13#10+
            '4330402 - Instala��o de portas, janelas, tetos, divis�rias e arm�rios embutidos de qualquer material'+#13#10+
            '4330403 - Obras de acabamento em gesso e estuque'+#13#10+
            '4330404 - Servi�os de pintura de edif�cios em geral'+#13#10+
            '4330405 - Aplica��o de revestimentos e de resinas em interiores e exteriores'+#13#10+
            '4330499 - Outras obras de acabamento da constru��o'+#13#10+
            '4391600 - Obras de funda��es'+#13#10+
            '4399101 - Administra��o de obras'+#13#10+
            '4399102 - Montagem e desmontagem de andaimes e outras estruturas tempor�rias'+#13#10+
            '4399103 - Obras de alvenaria'+#13#10+
            '4399104 - Servi�os de opera��o e fornecimento de equipamentos para transporte e eleva��o de cargas e pessoas para uso em obras'+#13#10+
            '4399105 - Perfura��o e constru��o de po�os de �gua'+#13#10+
            '4399199 - Servi�os especializados para constru��o n�o especificados anteriormente'+#13#10+
            '4511101 - Com�rcio a varejo de autom�veis, camionetas e utilit�rios novos'+#13#10+
            '4511102 - Com�rcio a varejo de autom�veis, camionetas e utilit�rios usados'+#13#10+
            '4511103 - Com�rcio por atacado de autom�veis, camionetas e utilit�rios novos e usados'+#13#10+
            '4511104 - Com�rcio por atacado de caminh�es novos e usados'+#13#10+
            '4511105 - Com�rcio por atacado de reboques e semireboques novos e usados'+#13#10+
            '4511106 - Com�rcio por atacado de �nibus e micro-�nibus novos e usados'+#13#10+
            '4512901 - Representantes comerciais e agentes do com�rcio de ve�culos automotores'+#13#10+
            '4512902 - Com�rcio sob consigna��o de ve�culos automotores'+#13#10+
            '4520001 - Servi�os de manuten��o e repara��o mec�nica de ve�culos automotores'+#13#10+
            '4520002 - Servi�os de lanternagem ou funilaria e pintura de ve�culos automotores'+#13#10+
            '4520003 - Servi�os de manuten��o e repara��o el�trica de ve�culos automotores'+#13#10+
            '4520004 - Servi�os de alinhamento e balanceamento de ve�culos automotores'+#13#10+
            '4520005 - Servi�os de lavagem, lubrifica��o e polimento de ve�culos automotores'+#13#10+
            '4520006 - Servi�os de borracharia para ve�culos automotores'+#13#10+
            '4520007 - Servi�os de instala��o, manuten��o e repara��o de acess�rios para ve�culos automotores'+#13#10+
            '4520008 - Servi�os de capotaria'+#13#10+
            '4530701 - Com�rcio por atacado de pe�as e acess�rios novos para ve�culos automotores'+#13#10+
            '4530702 - Com�rcio por atacado de pneum�ticos e c�maras-de-ar'+#13#10+
            '4530703 - Com�rcio a varejo de pe�as e acess�rios novos para ve�culos automotores'+#13#10+
            '4530704 - Com�rcio a varejo de pe�as e acess�rios usados para ve�culos automotores'+#13#10+
            '4530705 - Com�rcio a varejo de pneum�ticos e c�maras-de-ar'+#13#10+
            '4530706 - Representantes comerciais e agentes do com�rcio de pe�as e acess�rios novos e usados para ve�culos automotores'+#13#10+
            '4541201 - Com�rcio por atacado de motocicletas e motonetas'+#13#10+
            '4541202 - Com�rcio por atacado de pe�as e acess�rios para motocicletas e motonetas'+#13#10+
            '4541203 - Com�rcio a varejo de motocicletas e motonetas novas'+#13#10+
            '4541204 - Com�rcio a varejo de motocicletas e motonetas usadas'+#13#10+
            '4541206 - Com�rcio a varejo de pe�as e acess�rios novos para motocicletas e motonetas'+#13#10+
            '4541207 - Com�rcio a varejo de pe�as e acess�rios usados para motocicletas e motonetas'+#13#10+
            '4542101 - Representantes comerciais e agentes do com�rcio de motocicletas e motonetas, pe�as e acess�rios'+#13#10+
            '4542102 - Com�rcio sob consigna��o de motocicletas e motonetas'+#13#10+
            '4543900 - Manuten��o e repara��o de motocicletas e motonetas'+#13#10+
            '4611700 - Representantes comerciais e agentes do com�rcio de mat�rias-primas agr�colas e animais vivos'+#13#10+
            '4612500 - Representantes comerciais e agentes do com�rcio de combust�veis, minerais, produtos sider�rgicos e qu�micos'+#13#10+
            '4613300 - Representantes comerciais e agentes do com�rcio de madeira, material de constru��o e ferragens'+#13#10+
            '4614100 - Representantes comerciais e agentes do com�rcio de m�quinas, equipamentos, embarca��es e aeronaves'+#13#10+
            '4615000 - Representantes comerciais e agentes do com�rcio de eletrodom�sticos, m�veis e artigos de uso dom�stico'+#13#10+
            '4616800 - Representantes comerciais e agentes do com�rcio de t�xteis, vestu�rio, cal�ados e artigos de viagem'+#13#10+
            '4617600 - Representantes comerciais e agentes do com�rcio de produtos aliment�cios, bebidas e fumo'+#13#10+
            '4618401 - Representantes comerciais e agentes do com�rcio de medicamentos, cosm�ticos e produtos de perfumaria'+#13#10+
            '4618402 - Representantes comerciais e agentes do com�rcio de instrumentos e materiais odonto-m�dico-hospitalares'+#13#10+
            '4618403 - Representantes comerciais e agentes do com�rcio de jornais, revistas e outras publica��es'+#13#10+
            '4618499 - Outros representantes comerciais e agentes do com�rcio especializado em produtos n�o especificados anteriormente'+#13#10+
            '4619200 - Representantes comerciais e agentes do com�rcio de mercadorias em geral n�o especializado'+#13#10+
            '4621400 - Com�rcio atacadista de caf� em gr�o'+#13#10+
            '4622200 - Com�rcio atacadista de soja'+#13#10+
            '4623101 - Com�rcio atacadista de animais vivos'+#13#10+
            '4623102 - Com�rcio atacadista de couros, l�s, peles e outros subprodutos n�o comest�veis de origem animal'+#13#10+
            '4623103 - Com�rcio atacadista de algod�o'+#13#10+
            '4623104 - Com�rcio atacadista de fumo em folha n�o beneficiado'+#13#10+
            '4623105 - Com�rcio atacadista de cacau'+#13#10+
            '4623106 - Com�rcio atacadista de sementes, flores, plantas e gramas'+#13#10+
            '4623107 - Com�rcio atacadista de sisal'+#13#10+
            '4623108 - Com�rcio atacadista de mat�rias-primas agr�colas com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4623109 - Com�rcio atacadista de alimentos para animais'+#13#10+
            '4623199 - Com�rcio atacadista de mat�rias-primas agr�colas n�o especificadas anteriormente'+#13#10+
            '4631100 - Com�rcio atacadista de leite e latic�nios'+#13#10+
            '4632001 - Com�rcio atacadista de cereais e leguminosas beneficiados'+#13#10+
            '4632002 - Com�rcio atacadista de farinhas, amidos e f�culas'+#13#10+
            '4632003 - Com�rcio atacadista de cereais e leguminosas beneficiados, farinhas, amidos e f�culas, com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4633801 - Com�rcio atacadista de frutas, verduras, ra�zes, tub�rculos, hortali�as e legumes frescos'+#13#10+
            '4633802 - Com�rcio atacadista de aves vivas e ovos'+#13#10+
            '4633803 - Com�rcio atacadista de coelhos e outros pequenos animais vivos para alimenta��o'+#13#10+
            '4634601 - Com�rcio atacadista de carnes bovinas e su�nas e derivados'+#13#10+
            '4634602 - Com�rcio atacadista de aves abatidas e derivados'+#13#10+
            '4634603 - Com�rcio atacadista de pescados e frutos do mar'+#13#10+
            '4634699 - Com�rcio atacadista de carnes e derivados de outros animais'+#13#10+
            '4635401 - Com�rcio atacadista de �gua mineral'+#13#10+
            '4635402 - Com�rcio atacadista de cerveja, chope e refrigerante'+#13#10+
            '4635403 - Com�rcio atacadista de bebidas com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4635499 - Com�rcio atacadista de bebidas n�o especificadas anteriormente'+#13#10+
            '4636201 - Com�rcio atacadista de fumo beneficiado'+#13#10+
            '4636202 - Com�rcio atacadista de cigarros, cigarrilhas e charutos'+#13#10+
            '4637101 - Com�rcio atacadista de caf� torrado, mo�do e sol�vel'+#13#10+
            '4637102 - Com�rcio atacadista de a��car'+#13#10+
            '4637103 - Com�rcio atacadista de �leos e gorduras'+#13#10+
            '4637104 - Com�rcio atacadista de p�es, bolos, biscoitos e similares'+#13#10+
            '4637105 - Com�rcio atacadista de massas aliment�cias'+#13#10+
            '4637106 - Com�rcio atacadista de sorvetes'+#13#10+
            '4637107 - Com�rcio atacadista de chocolates, confeitos, balas, bombons e semelhantes'+#13#10+
            '4637199 - Com�rcio atacadista especializado em outros produtos aliment�cios n�o especificados anteriormente'+#13#10+
            '4639701 - Com�rcio atacadista de produtos aliment�cios em geral'+#13#10+
            '4639702 - Com�rcio atacadista de produtos aliment�cios em geral, com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4641901 - Com�rcio atacadista de tecidos'+#13#10+
            '4641902 - Com�rcio atacadista de artigos de cama, mesa e banho'+#13#10+
            '4641903 - Com�rcio atacadista de artigos de armarinho'+#13#10+
            '4642701 - Com�rcio atacadista de artigos do vestu�rio e acess�rios, exceto profissionais e de seguran�a'+#13#10+
            '4642702 - Com�rcio atacadista de roupas e acess�rios para uso profissional e de seguran�a do trabalho'+#13#10+
            '4643501 - Com�rcio atacadista de cal�ados'+#13#10+
            '4643502 - Com�rcio atacadista de bolsas, malas e artigos de viagem'+#13#10+
            '4644301 - Com�rcio atacadista de medicamentos e drogas de uso humano'+#13#10+
            '4644302 - Com�rcio atacadista de medicamentos e drogas de uso veterin�rio'+#13#10+
            '4645101 - Com�rcio atacadista de instrumentos e materiais para uso m�dico, cir�rgico, hospitalar e de laborat�rios'+#13#10+
            '4645102 - Com�rcio atacadista de pr�teses e artigos de ortopedia'+#13#10+
            '4645103 - Com�rcio atacadista de produtos odontol�gicos'+#13#10+
            '4646001 - Com�rcio atacadista de cosm�ticos e produtos de perfumaria'+#13#10+
            '4646002 - Com�rcio atacadista de produtos de higiene pessoal'+#13#10+
            '4647801 - Com�rcio atacadista de artigos de escrit�rio e de papelaria'+#13#10+
            '4647802 - Com�rcio atacadista de livros, jornais e outras publica��es'+#13#10+
            '4649401 - Com�rcio atacadista de equipamentos el�tricos de uso pessoal e dom�stico'+#13#10+
            '4649402 - Com�rcio atacadista de aparelhos eletr�nicos de uso pessoal e dom�stico'+#13#10+
            '4649403 - Com�rcio atacadista de bicicletas, triciclos e outros ve�culos recreativos'+#13#10+
            '4649404 - Com�rcio atacadista de m�veis e artigos de colchoaria'+#13#10+
            '4649405 - Com�rcio atacadista de artigos de tape�aria; persianas e cortinas'+#13#10+
            '4649406 - Com�rcio atacadista de lustres, lumin�rias e abajures'+#13#10+
            '4649407 - Com�rcio atacadista de filmes, CDs, DVDs, fitas e discos'+#13#10+
            '4649408 - Com�rcio atacadista de produtos de higiene, limpeza e conserva��o domiciliar'+#13#10+
            '4649409 - Com�rcio atacadista de produtos de higiene, limpeza e conserva��o domiciliar, com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4649410 - Com�rcio atacadista de j�ias, rel�gios e bijuterias, inclusive pedras preciosas e semipreciosas lapidadas'+#13#10+
            '4649499 - Com�rcio atacadista de outros equipamentos e artigos de uso pessoal e dom�stico n�o especificados anteriormente'+#13#10+
            '4651601 - Com�rcio atacadista de equipamentos de inform�tica'+#13#10+
            '4651602 - Com�rcio atacadista de suprimentos para inform�tica'+#13#10+
            '4652400 - Com�rcio atacadista de componentes eletr�nicos e equipamentos de telefonia e comunica��o'+#13#10+
            '4661300 - Com�rcio atacadista de m�quinas, aparelhos e equipamentos para uso agropecu�rio; partes e pe�as'+#13#10+
            '4662100 - Com�rcio atacadista de m�quinas, equipamentos para terraplenagem, minera��o e constru��o; partes e pe�as'+#13#10+
            '4663000 - Com�rcio atacadista de m�quinas e equipamentos para uso industrial; partes e pe�as'+#13#10+
            '4664800 - Com�rcio atacadista de m�quinas, aparelhos e equipamentos para uso odonto-m�dico-hospitalar; partes e pe�as'+#13#10+
            '4665600 - Com�rcio atacadista de m�quinas e equipamentos para uso comercial; partes e pe�as'+#13#10+
            '4669901 - Com�rcio atacadista de bombas e compressores; partes e pe�as'+#13#10+
            '4669999 - Com�rcio atacadista de outras m�quinas e equipamentos n�o especificados anteriormente; partes e pe�as'+#13#10+
            '4671100 - Com�rcio atacadista de madeira e produtos derivados'+#13#10+
            '4672900 - Com�rcio atacadista de ferragens e ferramentas'+#13#10+
            '4673700 - Com�rcio atacadista de material el�trico'+#13#10+
            '4674500 - Com�rcio atacadista de cimento'+#13#10+
            '4679601 - Com�rcio atacadista de tintas, vernizes e similares'+#13#10+
            '4679602 - Com�rcio atacadista de m�rmores e granitos'+#13#10+
            '4679603 - Com�rcio atacadista de vidros, espelhos e vitrais'+#13#10+
            '4679604 - Com�rcio atacadista especializado de materiais de constru��o n�o especificados anteriormente'+#13#10+
            '4679699 - Com�rcio atacadista de materiais de constru��o em geral'+#13#10+
            '4681801 - Com�rcio atacadista de �lcool carburante, biodiesel, gasolina e demais derivados de petr�leo, exceto lubrificantes, n�o realizado por transportador retalhista (TRR)'+#13#10+
            '4681802 - Com�rcio atacadista de combust�veis realizado por transportador retalhista (TRR)'+#13#10+
            '4681803 - Com�rcio atacadista de combust�veis de origem vegetal, exceto �lcool carburante'+#13#10+
            '4681804 - Com�rcio atacadista de combust�veis de origem mineral em bruto'+#13#10+
            '4681805 - Com�rcio atacadista de lubrificantes'+#13#10+
            '4682600 - Com�rcio atacadista de g�s liquefeito de petr�leo (GLP)'+#13#10+
            '4683400 - Com�rcio atacadista de defensivos agr�colas, adubos, fertilizantes e corretivos do solo'+#13#10+
            '4684201 - Com�rcio atacadista de resinas e elast�meros'+#13#10+
            '4684202 - Com�rcio atacadista de solventes'+#13#10+
            '4684299 - Com�rcio atacadista de outros produtos qu�micos e petroqu�micos n�o especificados anteriormente'+#13#10+
            '4685100 - Com�rcio atacadista de produtos sider�rgicos e metal�rgicos, exceto para constru��o'+#13#10+
            '4686901 - Com�rcio atacadista de papel e papel�o em bruto'+#13#10+
            '4686902 - Com�rcio atacadista de embalagens'+#13#10+
            '4687701 - Com�rcio atacadista de res�duos de papel e papel�o'+#13#10+
            '4687702 - Com�rcio atacadista de res�duos e sucatas n�o met�licos, exceto de papel e papel�o'+#13#10+
            '4687703 - Com�rcio atacadista de res�duos e sucatas met�licos'+#13#10+
            '4689301 - Com�rcio atacadista de produtos da extra��o mineral, exceto combust�veis'+#13#10+
            '4689302 - Com�rcio atacadista de fios e fibras beneficiados'+#13#10+
            '4689399 - Com�rcio atacadista especializado em outros produtos intermedi�rios n�o especificados anteriormente'+#13#10+
            '4691500 - Com�rcio atacadista de mercadorias em geral, com predomin�ncia de produtos aliment�cios'+#13#10+
            '4692300 - Com�rcio atacadista de mercadorias em geral, com predomin�ncia de insumos agropecu�rios'+#13#10+
            '4693100 - Com�rcio atacadista de mercadorias em geral, sem predomin�ncia de alimentos ou de insumos agropecu�rios'+#13#10+
            '4711301 - Com�rcio varejista de mercadorias em geral, com predomin�ncia de produtos aliment�cios - hipermercados'+#13#10+
            '4711302 - Com�rcio varejista de mercadorias em geral, com predomin�ncia de produtos aliment�cios - supermercados'+#13#10+
            '4712100 - Com�rcio varejista de mercadorias em geral, com predomin�ncia de produtos aliment�cios - minimercados, mercearias e armaz�ns'+#13#10+
            '4713002 - Lojas de variedades, exceto lojas de departamentos ou magazines'+#13#10+
            '4713004 - Lojas de departamentos ou magazines, exceto lojas francas (Duty free)'+#13#10+
            '4713005 - Lojas francas (Duty Free) de aeroportos, portos e em fronteiras terrestres'+#13#10+
            '4721102 - Padaria e confeitaria com predomin�ncia de revenda'+#13#10+
            '4721103 - Com�rcio varejista de latic�nios e frios'+#13#10+
            '4721104 - Com�rcio varejista de doces, balas, bombons e semelhantes'+#13#10+
            '4722901 - Com�rcio varejista de carnes - a�ougues'+#13#10+
            '4722902 - Peixaria'+#13#10+
            '4723700 - Com�rcio varejista de bebidas'+#13#10+
            '4724500 - Com�rcio varejista de hortifrutigranjeiros'+#13#10+
            '4729601 - Tabacaria'+#13#10+
            '4729602 - Com�rcio varejista de mercadorias em lojas de conveni�ncia'+#13#10+
            '4729699 - Com�rcio varejista de produtos aliment�cios em geral ou especializado em produtos aliment�cios n�o especificados anteriormente'+#13#10+
            '4731800 - Com�rcio varejista de combust�veis para ve�culos automotores'+#13#10+
            '4732600 - Com�rcio varejista de lubrificantes'+#13#10+
            '4741500 - Com�rcio varejista de tintas e materiais para pintura'+#13#10+
            '4742300 - Com�rcio varejista de material el�trico'+#13#10+
            '4743100 - Com�rcio varejista de vidros'+#13#10+
            '4744001 - Com�rcio varejista de ferragens e ferramentas'+#13#10+
            '4744002 - Com�rcio varejista de madeira e artefatos'+#13#10+
            '4744003 - Com�rcio varejista de materiais hidr�ulicos'+#13#10+
            '4744004 - Com�rcio varejista de cal, areia, pedra britada, tijolos e telhas'+#13#10+
            '4744005 - Com�rcio varejista de materiais de constru��o n�o especificados anteriormente'+#13#10+
            '4744006 - Com�rcio varejista de pedras para revestimento'+#13#10+
            '4744099 - Com�rcio varejista de materiais de constru��o em geral'+#13#10+
            '4751201 - Com�rcio varejista especializado de equipamentos e suprimentos de inform�tica'+#13#10+
            '4751202 - Recarga de cartuchos para equipamentos de inform�tica'+#13#10+
            '4752100 - Com�rcio varejista especializado de equipamentos de telefonia e comunica��o'+#13#10+
            '4753900 - Com�rcio varejista especializado de eletrodom�sticos e equipamentos de �udio e v�deo'+#13#10+
            '4754701 - Com�rcio varejista de m�veis'+#13#10+
            '4754702 - Com�rcio varejista de artigos de colchoaria'+#13#10+
            '4754703 - Com�rcio varejista de artigos de ilumina��o'+#13#10+
            '4755501 - Com�rcio varejista de tecidos'+#13#10+
            '4755502 - Comercio varejista de artigos de armarinho'+#13#10+
            '4755503 - Comercio varejista de artigos de cama, mesa e banho'+#13#10+
            '4756300 - Com�rcio varejista especializado de instrumentos musicais e acess�rios'+#13#10+
            '4757100 - Com�rcio varejista especializado de pe�as e acess�rios para aparelhos eletroeletr�nicos para uso dom�stico, exceto inform�tica e comunica��o'+#13#10+
            '4759801 - Com�rcio varejista de artigos de tape�aria, cortinas e persianas'+#13#10+
            '4759899 - Com�rcio varejista de outros artigos de uso dom�stico n�o especificados anteriormente'+#13#10+
            '4761001 - Com�rcio varejista de livros'+#13#10+
            '4761002 - Com�rcio varejista de jornais e revistas'+#13#10+
            '4761003 - Com�rcio varejista de artigos de papelaria'+#13#10+
            '4762800 - Com�rcio varejista de discos, CDs, DVDs e fitas'+#13#10+
            '4763601 - Com�rcio varejista de brinquedos e artigos recreativos'+#13#10+
            '4763602 - Com�rcio varejista de artigos esportivos'+#13#10+
            '4763603 - Com�rcio varejista de bicicletas e triciclos; pe�as e acess�rios'+#13#10+
            '4763604 - Com�rcio varejista de artigos de ca�a, pesca e camping'+#13#10+
            '4763605 - Com�rcio varejista de embarca��es e outros ve�culos recreativos; pe�as e acess�rios'+#13#10+
            '4771701 - Com�rcio varejista de produtos farmac�uticos, sem manipula��o de f�rmulas'+#13#10+
            '4771702 - Com�rcio varejista de produtos farmac�uticos, com manipula��o de f�rmulas'+#13#10+
            '4771703 - Com�rcio varejista de produtos farmac�uticos homeop�ticos'+#13#10+
            '4771704 - Com�rcio varejista de medicamentos veterin�rios'+#13#10+
            '4772500 - Com�rcio varejista de cosm�ticos, produtos de perfumaria e de higiene pessoal'+#13#10+
            '4773300 - Com�rcio varejista de artigos m�dicos e ortop�dicos'+#13#10+
            '4774100 - Com�rcio varejista de artigos de �ptica'+#13#10+
            '4781400 - Com�rcio varejista de artigos do vestu�rio e acess�rios'+#13#10+
            '4782201 - Com�rcio varejista de cal�ados'+#13#10+
            '4782202 - Com�rcio varejista de artigos de viagem'+#13#10+
            '4783101 - Com�rcio varejista de artigos de joalheria'+#13#10+
            '4783102 - Com�rcio varejista de artigos de relojoaria'+#13#10+
            '4784900 - Com�rcio varejista de g�s liq�efeito de petr�leo (GLP)'+#13#10+
            '4785701 - Com�rcio varejista de antiguidades'+#13#10+
            '4785799 - Com�rcio varejista de outros artigos usados'+#13#10+
            '4789001 - Com�rcio varejista de suvenires, bijuterias e artesanatos'+#13#10+
            '4789002 - Com�rcio varejista de plantas e flores naturais'+#13#10+
            '4789003 - Com�rcio varejista de objetos de arte'+#13#10+
            '4789004 - Com�rcio varejista de animais vivos e de artigos e alimentos para animais de estima��o'+#13#10+
            '4789005 - Com�rcio varejista de produtos saneantes domissanit�rios'+#13#10+
            '4789006 - Com�rcio varejista de fogos de artif�cio e artigos pirot�cnicos'+#13#10+
            '4789007 - Com�rcio varejista de equipamentos para escrit�rio'+#13#10+
            '4789008 - Com�rcio varejista de artigos fotogr�ficos e para filmagem'+#13#10+
            '4789009 - Com�rcio varejista de armas e muni��es'+#13#10+
            '4789099 - Com�rcio varejista de outros produtos n�o especificados anteriormente'+#13#10+
            '4911600 - Transporte ferrovi�rio de carga'+#13#10+
            '4912401 - Transporte ferrovi�rio de passageiros intermunicipal e interestadual'+#13#10+
            '4912402 - Transporte ferrovi�rio de passageiros municipal e em regi�o metropolitana'+#13#10+
            '4912403 - Transporte metrovi�rio'+#13#10+
            '4921301 - Transporte rodovi�rio coletivo de passageiros, com itiner�rio fixo, municipal'+#13#10+
            '4921302 - Transporte rodovi�rio coletivo de passageiros, com itiner�rio fixo, intermunicipal em regi�o metropolitana'+#13#10+
            '4922101 - Transporte rodovi�rio coletivo de passageiros, com itiner�rio fixo, intermunicipal, exceto em regi�o metropolitana'+#13#10+
            '4922102 - Transporte rodovi�rio coletivo de passageiros, com itiner�rio fixo, interestadual'+#13#10+
            '4922103 - Transporte rodovi�rio coletivo de passageiros, com itiner�rio fixo, internacional'+#13#10+
            '4923001 - Servi�o de t�xi'+#13#10+
            '4923002 - Servi�o de transporte de passageiros - loca��o de autom�veis com motorista'+#13#10+
            '4924800 - Transporte escolar'+#13#10+
            '4929901 - Transporte rodovi�rio coletivo de passageiros, sob regime de fretamento, municipal'+#13#10+
            '4929902 - Transporte rodovi�rio coletivo de passageiros, sob regime de fretamento, intermunicipal, interestadual e internacional'+#13#10+
            '4929903 - Organiza��o de excurs�es em ve�culos rodovi�rios pr�prios, municipal'+#13#10+
            '4929904 - Organiza��o de excurs�es em ve�culos rodovi�rios pr�prios, intermunicipal, interestadual e internacional'+#13#10+
            '4929999 - Outros transportes rodovi�rios de passageiros n�o especificados anteriormente'+#13#10+
            '4930201 - Transporte rodovi�rio de carga, exceto produtos perigosos e mudan�as, municipal'+#13#10+
            '4930202 - Transporte rodovi�rio de carga, exceto produtos perigosos e mudan�as, intermunicipal, interestadual e internacional'+#13#10+
            '4930203 - Transporte rodovi�rio de produtos perigosos'+#13#10+
            '4930204 - Transporte rodovi�rio de mudan�as'+#13#10+
            '4940000 - Transporte dutovi�rio'+#13#10+
            '4950700 - Trens tur�sticos, telef�ricos e similares'+#13#10+
            '5011401 - Transporte mar�timo de cabotagem - Carga'+#13#10+
            '5011402 - Transporte mar�timo de cabotagem - Passageiros'+#13#10+
            '5012201 - Transporte mar�timo de longo curso - Carga'+#13#10+
            '5012202 - Transporte mar�timo de longo curso - Passageiros'+#13#10+
            '5021101 - Transporte por navega��o interior de carga, municipal, exceto travessia'+#13#10+
            '5021102 - Transporte por navega��o interior de carga, intermunicipal, interestadual e internacional, exceto travessia'+#13#10+
            '5022001 - Transporte por navega��o interior de passageiros em linhas regulares, municipal, exceto travessia'+#13#10+
            '5022002 - Transporte por navega��o interior de passageiros em linhas regulares, intermunicipal, interestadual e internacional, exceto travessia'+#13#10+
            '5030101 - Navega��o de apoio mar�timo'+#13#10+
            '5030102 - Navega��o de apoio portu�rio'+#13#10+
            '5030103 - Servi�o de rebocadores e empurradores'+#13#10+
            '5091201 - Transporte por navega��o de travessia, municipal'+#13#10+
            '5091202 - Transporte por navega��o de travessia, intermunicipal, interestadual e internacional'+#13#10+
            '5099801 - Transporte aquavi�rio para passeios tur�sticos'+#13#10+
            '5099899 - Outros transportes aquavi�rios n�o especificados anteriormente'+#13#10+
            '5111100 - Transporte a�reo de passageiros regular'+#13#10+
            '5112901 - Servi�o de t�xi a�reo e loca��o de aeronaves com tripula��o'+#13#10+
            '5112999 - Outros servi�os de transporte a�reo de passageiros n�o regular'+#13#10+
            '5120000 - Transporte a�reo de carga'+#13#10+
            '5130700 - Transporte espacial'+#13#10+
            '5211701 - Armaz�ns gerais - emiss�o de warrant'+#13#10+
            '5211702 - Guarda-m�veis'+#13#10+
            '5211799 - Dep�sitos de mercadorias para terceiros, exceto armaz�ns gerais e guarda-m�veis'+#13#10+
            '5212500 - Carga e descarga'+#13#10+
            '5221400 - Concession�rias de rodovias, pontes, t�neis e servi�os relacionados'+#13#10+
            '5222200 - Terminais rodovi�rios e ferrovi�rios'+#13#10+
            '5223100 - Estacionamento de ve�culos'+#13#10+
            '5229001 - Servi�os de apoio ao transporte por t�xi, inclusive centrais de chamada'+#13#10+
            '5229002 - Servi�os de reboque de ve�culos'+#13#10+
            '5229099 - Outras atividades auxiliares dos transportes terrestres n�o especificadas anteriormente'+#13#10+
            '5231101 - Administra��o da infraestrutura portu�ria'+#13#10+
            '5231102 - Atividades do Operador Portu�rio'+#13#10+
            '5231103 - Gest�o de terminais aquavi�rios'+#13#10+
            '5232000 - Atividades de agenciamento mar�timo'+#13#10+
            '5239701 - Servi�os de praticagem'+#13#10+
            '5239799 - Atividades auxiliares dos transportes aquavi�rios n�o especificadas anteriormente'+#13#10+
            '5240101 - Opera��o dos aeroportos e campos de aterrissagem'+#13#10+
            '5240199 - Atividades auxiliares dos transportes a�reos, exceto opera��o dos aeroportos e campos de aterrissagem'+#13#10+
            '5250801 - Comissaria de despachos'+#13#10+
            '5250802 - Atividades de despachantes aduaneiros'+#13#10+
            '5250803 - Agenciamento de cargas, exceto para o transporte mar�timo'+#13#10+
            '5250804 - Organiza��o log�stica do transporte de carga'+#13#10+
            '5250805 - Operador de transporte multimodal - OTM'+#13#10+
            '5310501 - Atividades do Correio Nacional'+#13#10+
            '5310502 - Atividades de�franqueadas e permission�rias do Correio Nacional'+#13#10+
            '5320201 - Servi�os de malote n�o realizados pelo Correio Nacional'+#13#10+
            '5320202 - Servi�os de entrega r�pida'+#13#10+
            '5510801 - Hot�is'+#13#10+
            '5510802 - Apart-hot�is'+#13#10+
            '5510803 - Mot�is'+#13#10+
            '5590601 - Albergues, exceto assistenciais'+#13#10+
            '5590602 - Campings'+#13#10+
            '5590603 - Pens�es (alojamento)'+#13#10+
            '5590699 - Outros alojamentos n�o especificados anteriormente'+#13#10+
            '5611201 - Restaurantes e similares'+#13#10+
            '5611203 - Lanchonetes, casas de ch�, de sucos e similares'+#13#10+
            '5611204 - Bares e outros estabelecimentos especializados em servir bebidas, sem entretenimento'+#13#10+
            '5611205 - Bares e outros estabelecimentos especializados em servir bebidas, com entretenimento'+#13#10+
            '5612100 - Servi�os ambulantes de alimenta��o'+#13#10+
            '5620101 - Fornecimento de alimentos preparados preponderantemente para empresas'+#13#10+
            '5620102 - Servi�os de alimenta��o para eventos e recep��es - buf�'+#13#10+
            '5620103 - Cantinas - servi�os de alimenta��o privativos'+#13#10+
            '5620104 - Fornecimento de alimentos preparados preponderantemente para consumo domiciliar'+#13#10+
            '5811500 - Edi��o de livros'+#13#10+
            '5812301 - Edi��o de jornais di�rios'+#13#10+
            '5812302 - Edi��o de jornais n�o di�rios'+#13#10+
            '5813100 - Edi��o de revistas'+#13#10+
            '5819100 - Edi��o de cadastros, listas e outros produtos gr�ficos'+#13#10+
            '5821200 - Edi��o integrada � impress�o de livros'+#13#10+
            '5822101 - Edi��o integrada � impress�o de jornais di�rios'+#13#10+
            '5822102 - Edi��o integrada � impress�o de jornais n�o di�rios'+#13#10+
            '5823900 - Edi��o integrada � impress�o de revistas'+#13#10+
            '5829800 - Edi��o integrada � impress�o de cadastros, listas e outros produtos gr�ficos'+#13#10+
            '5911101 - Est�dios cinematogr�ficos'+#13#10+
            '5911102 - Produ��o de filmes para publicidade'+#13#10+
            '5911199 - Atividades de produ��o cinematogr�fica, de v�deos e de programas de televis�o n�o especificadas anteriormente'+#13#10+
            '5912001 - Servi�os de dublagem'+#13#10+
            '5912002 - Servi�os de mixagem sonora em produ��o audiovisual'+#13#10+
            '5912099 - Atividades de p�s-produ��o cinematogr�fica, de v�deos e de programas de televis�o n�o especificadas anteriormente'+#13#10+
            '5913800 - Distribui��o cinematogr�fica, de v�deo e de programas de televis�o'+#13#10+
            '5914600 - Atividades de exibi��o cinematogr�fica'+#13#10+
            '5920100 - Atividades de grava��o de som e de edi��o de m�sica'+#13#10+
            '6010100 - Atividades de r�dio'+#13#10+
            '6021700 - Atividades de televis�o aberta'+#13#10+
            '6022501 - Programadoras'+#13#10+
            '6022502 - Atividades relacionadas � televis�o por assinatura, exceto programadoras'+#13#10+
            '6110801 - Servi�os de telefonia fixa comutada - STFC'+#13#10+
            '6110802 - Servi�os de redes de transporte de telecomunica��es - SRTT'+#13#10+
            '6110803 - Servi�os de comunica��o multim�dia - SCM'+#13#10+
            '6110899 - Servi�os de telecomunica��es por fio n�o especificados anteriormente'+#13#10+
            '6120501 - Telefonia m�vel celular'+#13#10+
            '6120502 - Servi�o m�vel especializado - SME'+#13#10+
            '6120599 - Servi�os de telecomunica��es sem fio n�o especificados anteriormente'+#13#10+
            '6130200 - Telecomunica��es por sat�lite'+#13#10+
            '6141800 - Operadoras de televis�o por assinatura por cabo'+#13#10+
            '6142600 - Operadoras de televis�o por assinatura por micro-ondas'+#13#10+
            '6143400 - Operadoras de televis�o por assinatura por sat�lite'+#13#10+
            '6190601 - Provedores de acesso �s redes de comunica��es'+#13#10+
            '6190602 - Provedores de voz sobre protocolo Internet - VOIP'+#13#10+
            '6190699 - Outras atividades de telecomunica��es n�o especificadas anteriormente'+#13#10+
            '6201501 - Desenvolvimento de programas de computador sob encomenda'+#13#10+
            '6201502 - Web desing'+#13#10+
            '6202300 - Desenvolvimento e licenciamento de programas de computador customiz�veis'+#13#10+
            '6203100 - Desenvolvimento e licenciamento de programas de computador n�o customiz�veis'+#13#10+
            '6204000 - Consultoria em tecnologia da informa��o'+#13#10+
            '6209100 - Suporte t�cnico, manuten��o e outros servi�os em tecnologia da informa��o'+#13#10+
            '6311900 - Tratamento de dados, provedores de servi�os de aplica��o e servi�os de hospedagem na Internet'+#13#10+
            '6319400 - Portais, provedores de conte�do e outros servi�os de informa��o na Internet'+#13#10+
            '6391700 - Ag�ncias de not�cias'+#13#10+
            '6399200 - Outras atividades de presta��o de servi�os de informa��o n�o especificadas anteriormente'+#13#10+
            '6410700 - Banco Central'+#13#10+
            '6421200 - Bancos comerciais'+#13#10+
            '6422100 - Bancos m�ltiplos, com carteira comercial'+#13#10+
            '6423900 - Caixas econ�micas'+#13#10+
            '6424701 - Bancos cooperativos'+#13#10+
            '6424702 - Cooperativas centrais de cr�dito'+#13#10+
            '6424703 - Cooperativas de cr�dito m�tuo'+#13#10+
            '6424704 - Cooperativas de cr�dito rural'+#13#10+
            '6431000 - Bancos m�ltiplos, sem carteira comercial'+#13#10+
            '6432800 - Bancos de investimento'+#13#10+
            '6433600 - Bancos de desenvolvimento'+#13#10+
            '6434400 - Ag�ncias de fomento'+#13#10+
            '6435201 - Sociedades de cr�dito imobili�rio'+#13#10+
            '6435202 - Associa��es de poupan�a e empr�stimo'+#13#10+
            '6435203 - Companhias hipotec�rias'+#13#10+
            '6436100 - Sociedades de cr�dito, financiamento e investimento - financeiras'+#13#10+
            '6437900 - Sociedades de cr�dito ao microempreendedor'+#13#10+
            '6438701 - Bancos de c�mbio'+#13#10+
            '6438799 - Outras institui��es de intermedia��o n�o monet�ria n�o especificadas anteriormente'+#13#10+
            '6440900 - Arrendamento mercantil'+#13#10+
            '6450600 - Sociedades de capitaliza��o'+#13#10+
            '6461100 - Holdings de institui��es financeiras'+#13#10+
            '6462000 - Holdings de institui��es n�o financeiras'+#13#10+
            '6463800 - Outras sociedades de participa��o, exceto holdings'+#13#10+
            '6470101 - Fundos de investimento, exceto previdenci�rios e imobili�rios'+#13#10+
            '6470102 - Fundos de investimento previdenci�rios'+#13#10+
            '6470103 - Fundos de investimento imobili�rios'+#13#10+
            '6491300 - Sociedades de fomento mercantil - factoring'+#13#10+
            '6492100 - Securitiza��o de cr�ditos'+#13#10+
            '6493000 - Administra��o de cons�rcios para aquisi��o de bens e direitos'+#13#10+
            '6499901 - Clubes de investimento'+#13#10+
            '6499902 - Sociedades de investimento'+#13#10+
            '6499903 - Fundo garantidor de cr�dito'+#13#10+
            '6499904 - Caixas de financiamento de corpora��es'+#13#10+
            '6499905 - Concess�o de cr�dito pelas OSCIP'+#13#10+
            '6499999 - Outras atividades de servi�os financeiros n�o especificadas anteriormente'+#13#10+
            '6511101 - Sociedade seguradora de seguros vida'+#13#10+
            '6511102 - Planos de aux�lio-funeral'+#13#10+
            '6512000 - Sociedade seguradora de seguros n�o vida'+#13#10+
            '6520100 - Sociedade seguradora de seguros-sa�de'+#13#10+
            '6530800 - Resseguros'+#13#10+
            '6541300 - Previd�ncia complementar fechada'+#13#10+
            '6542100 - Previd�ncia complementar aberta'+#13#10+
            '6550200 - Planos de sa�de'+#13#10+
            '6611801 - Bolsa de valores'+#13#10+
            '6611802 - Bolsa de mercadorias'+#13#10+
            '6611803 - Bolsa de mercadorias e futuros'+#13#10+
            '6611804 - Administra��o de mercados de balc�o organizados'+#13#10+
            '6612601 - Corretoras de t�tulos e valores mobili�rios'+#13#10+
            '6612602 - Distribuidoras de t�tulos e valores mobili�rios'+#13#10+
            '6612603 - Corretoras de c�mbio'+#13#10+
            '6612604 - Corretoras de contratos de mercadorias'+#13#10+
            '6612605 - Agentes de investimentos em aplica��es financeiras'+#13#10+
            '6613400 - Administra��o de cart�es de cr�dito'+#13#10+
            '6619301 - Servi�os de liquida��o e cust�dia'+#13#10+
            '6619302 - Correspondentes de institui��es financeiras'+#13#10+
            '6619303 - Representa��es de bancos estrangeiros'+#13#10+
            '6619304 - Caixas eletr�nicos'+#13#10+
            '6619305 - Operadoras de cart�es de d�bito'+#13#10+
            '6619399 - Outras atividades auxiliares dos servi�os financeiros n�o especificadas anteriormente'+#13#10+
            '6621501 - Peritos e avaliadores de seguros'+#13#10+
            '6621502 - Auditoria e consultoria atuarial'+#13#10+
            '6622300 - Corretores e agentes de seguros, de planos de previd�ncia complementar e de sa�de'+#13#10+
            '6629100 - Atividades auxiliares dos seguros, da previd�ncia complementar e dos planos de sa�de n�o especificadas anteriormente'+#13#10+
            '6630400 - Atividades de administra��o de fundos por contrato ou comiss�o'+#13#10+
            '6810201 - Compra e venda de im�veis pr�prios'+#13#10+
            '6810202 - Aluguel de im�veis pr�prios'+#13#10+
            '6810203 - Loteamento de im�veis pr�prios'+#13#10+
            '6821801 - Corretagem na compra e venda e avalia��o de im�veis'+#13#10+
            '6821802 - Corretagem no aluguel de im�veis'+#13#10+
            '6822600 - Gest�o e administra��o da propriedade imobili�ria'+#13#10+
            '6911701 - Servi�os advocat�cios'+#13#10+
            '6911702 - Atividades auxiliares da justi�a'+#13#10+
            '6911703 - Agente de propriedade industrial'+#13#10+
            '6912500 - Cart�rios'+#13#10+
            '6920601 - Atividades de contabilidade'+#13#10+
            '6920602 - Atividades de consultoria e auditoria cont�bil e tribut�ria'+#13#10+
            '7020400 - Atividades de consultoria em gest�o empresarial, exceto consultoria t�cnica espec�fica'+#13#10+
            '7111100 - Servi�os de arquitetura'+#13#10+
            '7112000 - Servi�os de engenharia'+#13#10+
            '7119701 - Servi�os de cartografia, topografia e geod�sia'+#13#10+
            '7119702 - Atividades de estudos geol�gicos'+#13#10+
            '7119703 - Servi�os de desenho t�cnico relacionados � arquitetura e engenharia'+#13#10+
            '7119704 - Servi�os de per�cia t�cnica relacionados � seguran�a do trabalho'+#13#10+
            '7119799 - Atividades t�cnicas relacionadas � engenharia e arquitetura n�o especificadas anteriormente'+#13#10+
            '7120100 - Testes e an�lises t�cnicas'+#13#10+
            '7210000 - Pesquisa e desenvolvimento experimental em ci�ncias f�sicas e naturais'+#13#10+
            '7220700 - Pesquisa e desenvolvimento experimental em ci�ncias sociais e humanas'+#13#10+
            '7311400 - Ag�ncias de publicidade'+#13#10+
            '7312200 - Agenciamento de espa�os para publicidade, exceto em ve�culos de comunica��o'+#13#10+
            '7319001 - Cria��o de estandes para feiras e exposi��es'+#13#10+
            '7319002 - Promo��o de vendas'+#13#10+
            '7319003 - Marketing direto'+#13#10+
            '7319004 - Consultoria em publicidade'+#13#10+
            '7319099 - Outras atividades de publicidade n�o especificadas anteriormente'+#13#10+
            '7320300 - Pesquisas de mercado e de opini�o p�blica'+#13#10+
            '7410202 - Design de interiores'+#13#10+
            '7410203 - Desing de produto'+#13#10+
            '7410299 - Atividades de desing n�o especificadas anteriormente'+#13#10+
            '7420001 - Atividades de produ��o de fotografias, exceto a�rea e submarina'+#13#10+
            '7420002 - Atividades de produ��o de fotografias a�reas e submarinas'+#13#10+
            '7420003 - Laborat�rios fotogr�ficos'+#13#10+
            '7420004 - Filmagem de festas e eventos'+#13#10+
            '7420005 - Servi�os de microfilmagem'+#13#10+
            '7490101 - Servi�os de tradu��o, interpreta��o e similares'+#13#10+
            '7490102 - Escafandria e mergulho'+#13#10+
            '7490103 - Servi�os de agronomia e de consultoria �s atividades agr�colas e pecu�rias'+#13#10+
            '7490104 - Atividades de intermedia��o e agenciamento de servi�os e neg�cios em geral, exceto imobili�rios'+#13#10+
            '7490105 - Agenciamento de profissionais para atividades esportivas, culturais e art�sticas'+#13#10+
            '7490199 - Outras atividades profissionais, cient�ficas e t�cnicas n�o especificadas anteriormente'+#13#10+
            '7500100 - Atividades veterin�rias'+#13#10+
            '7711000 - Loca��o de autom�veis sem condutor'+#13#10+
            '7719501 - Loca��o de embarca��es sem tripula��o, exceto para fins recreativos'+#13#10+
            '7719502 - Loca��o de aeronaves sem tripula��o'+#13#10+
            '7719599 - Loca��o de outros meios de transporte n�o especificados anteriormente, sem condutor'+#13#10+
            '7721700 - Aluguel de equipamentos recreativos e esportivos'+#13#10+
            '7722500 - Aluguel de fitas de v�deo, DVDs e similares'+#13#10+
            '7723300 - Aluguel de objetos do vestu�rio, j�ias e acess�rios'+#13#10+
            '7729201 - Aluguel de aparelhos de jogos eletr�nicos'+#13#10+
            '7729202 - Aluguel de m�veis, utens�lios e aparelhos de uso dom�stico e pessoal; instrumentos musicais'+#13#10+
            '7729203 - Aluguel de material m�dico'+#13#10+
            '7729299 - Aluguel de outros objetos pessoais e dom�sticos n�o especificados anteriormente'+#13#10+
            '7731400 - Aluguel de m�quinas e equipamentos agr�colas sem operador'+#13#10+
            '7732201 - Aluguel de m�quinas e equipamentos para constru��o sem operador, exceto andaimes'+#13#10+
            '7732202 - Aluguel de andaimes'+#13#10+
            '7733100 - Aluguel de m�quinas e equipamentos para escrit�rio'+#13#10+
            '7739001 - Aluguel de m�quinas e equipamentos para extra��o de min�rios e petr�leo, sem operador'+#13#10+
            '7739002 - Aluguel de equipamentos cient�ficos, m�dicos e hospitalares, sem operador'+#13#10+
            '7739003 - Aluguel de palcos, coberturas e outras estruturas de uso tempor�rio, exceto andaimes'+#13#10+
            '7739099 - Aluguel de outras m�quinas e equipamentos comerciais e industriais n�o especificados anteriormente, sem operador'+#13#10+
            '7740300 - Gest�o de ativos intang�veis n�o financeiros'+#13#10+
            '7810800 - Sele��o e agenciamento de m�o de obra'+#13#10+
            '7820500 - Loca��o de m�o de obra tempor�ria'+#13#10+
            '7830200 - Fornecimento e gest�o de recursos humanos para terceiros'+#13#10+
            '7911200 - Ag�ncias de viagens'+#13#10+
            '7912100 - Operadores tur�sticos'+#13#10+
            '7990200 - Servi�os de reservas e outros servi�os de turismo n�o especificados anteriormente'+#13#10+
            '8011101 - Atividades de vigil�ncia e seguran�a privada'+#13#10+
            '8011102 - Servi�os de adestramento de c�es de guarda'+#13#10+
            '8012900 - Atividades de transporte de valores'+#13#10+
            '8020001 - Atividades de monitoramento de sistemas de seguran�a eletr�nico'+#13#10+
            '8020002 - Outras atividades de servi�os de seguran�a'+#13#10+
            '8030700 - Atividades de investiga��o particular'+#13#10+
            '8111700 - Servi�os combinados para apoio a edif�cios, exceto condom�nios prediais'+#13#10+
            '8112500 - Condom�nios prediais'+#13#10+
            '8121400 - Limpeza em pr�dios e em domic�lios'+#13#10+
            '8122200 - Imuniza��o e controle de pragas urbanas'+#13#10+
            '8129000 - Atividades de limpeza n�o especificadas anteriormente'+#13#10+
            '8130300 - Atividades paisag�sticas'+#13#10+
            '8211300 - Servi�os combinados de escrit�rio e apoio administrativo'+#13#10+
            '8219901 - Fotoc�pias'+#13#10+
            '8219999 - Prepara��o de documentos e servi�os especializados de apoio administrativo n�o especificados anteriormente'+#13#10+
            '8220200 - Atividades de teleatendimento'+#13#10+
            '8230001 - Servi�os de organiza��o de feiras, congressos, exposi��es e festas'+#13#10+
            '8230002 - Casas de festas e eventos'+#13#10+
            '8291100 - Atividades de cobran�a e informa��es cadastrais'+#13#10+
            '8292000 - Envasamento e empacotamento sob contrato'+#13#10+
            '8299701 - Medi��o de consumo de energia el�trica, g�s e �gua'+#13#10+
            '8299702 - Emiss�o de vales-alimenta��o, vales-transporte e similares'+#13#10+
            '8299703 - Servi�os de grava��o de carimbos, exceto confec��o'+#13#10+
            '8299704 - Leiloeiros independentes'+#13#10+
            '8299705 - Servi�os de levantamento de fundos sob contrato'+#13#10+
            '8299706 - Casas lot�ricas'+#13#10+
            '8299707 - Salas de acesso � Internet'+#13#10+
            '8299799 - Outras atividades de servi�os prestados principalmente �s empresas n�o especificadas anteriormente'+#13#10+
            '8411600 - Administra��o p�blica em geral'+#13#10+
            '8412400 - Regula��o das atividades de sa�de, educa��o, servi�os culturais e outros servi�os sociais'+#13#10+
            '8413200 - Regula��o das atividades econ�micas'+#13#10+
            '8421300 - Rela��es exteriores'+#13#10+
            '8422100 - Defesa'+#13#10+
            '8423000 - Justi�a'+#13#10+
            '8424800 - Seguran�a e ordem p�blica'+#13#10+
            '8425600 - Defesa Civil'+#13#10+
            '8430200 - Seguridade social obrigat�ria'+#13#10+
            '8511200 - Educa��o infantil - creche'+#13#10+
            '8512100 - Educa��o infantil - pr�-escola'+#13#10+
            '8513900 - Ensino fundamental'+#13#10+
            '8520100 - Ensino m�dio'+#13#10+
            '8531700 - Educa��o superior - gradua��o'+#13#10+
            '8532500 - Educa��o superior - gradua��o e p�s-gradua��o'+#13#10+
            '8533300 - Educa��o superior - p�s-gradua��o e extens�o'+#13#10+
            '8541400 - Educa��o profissional de n�vel t�cnico'+#13#10+
            '8542200 - Educa��o profissional de n�vel tecnol�gico'+#13#10+
            '8550301 - Administra��o de caixas escolares'+#13#10+
            '8550302 - Atividades de apoio � educa��o, exceto caixas escolares'+#13#10+
            '8591100 - Ensino de esportes'+#13#10+
            '8592901 - Ensino de dan�a'+#13#10+
            '8592902 - Ensino de artes c�nicas, exceto dan�a'+#13#10+
            '8592903 - Ensino de m�sica'+#13#10+
            '8592999 - Ensino de arte e cultura n�o especificado anteriormente'+#13#10+
            '8593700 - Ensino de idiomas'+#13#10+
            '8599601 - Forma��o de condutores'+#13#10+
            '8599602 - Cursos de pilotagem'+#13#10+
            '8599603 - Treinamento em inform�tica'+#13#10+
            '8599604 - Treinamento em desenvolvimento profissional e gerencial'+#13#10+
            '8599605 - Cursos preparat�rios para concursos'+#13#10+
            '8599699 - Outras atividades de ensino n�o especificadas anteriormente'+#13#10+
            '8610101 - Atividades de atendimento hospitalar, exceto pronto-socorro e unidades para atendimento a urg�ncias'+#13#10+
            '8610102 - Atividades de atendimento em pronto-socorro e unidades hospitalares para atendimento a urg�ncias'+#13#10+
            '8621601 - UTI m�vel'+#13#10+
            '8621602 - Servi�os m�veis de atendimento a urg�ncias, exceto por UTI m�vel'+#13#10+
            '8622400 - Servi�os de remo��o de pacientes, exceto os servi�os m�veis de atendimento a urg�ncias'+#13#10+
            '8630501 - Atividade m�dica ambulatorial com recursos para realiza��o de procedimentos cir�rgicos'+#13#10+
            '8630502 - Atividade m�dica ambulatorial com recursos para realiza��o de exames complementares'+#13#10+
            '8630503 - Atividade m�dica ambulatorial restrita a consultas'+#13#10+
            '8630504 - Atividade odontol�gica'+#13#10+
            '8630506 - Servi�os de vacina��o e imuniza��o humana'+#13#10+
            '8630507 - Atividades de reprodu��o humana assistida'+#13#10+
            '8630599 - Atividades de aten��o ambulatorial n�o especificadas anteriormente'+#13#10+
            '8640201 - Laborat�rios de anatomia patol�gica e citol�gica'+#13#10+
            '8640202 - Laborat�rios cl�nicos'+#13#10+
            '8640203 - Servi�os de di�lise e nefrologia'+#13#10+
            '8640204 - Servi�os de tomografia'+#13#10+
            '8640205 - Servi�os de diagn�stico por imagem com uso de radia��o ionizante, exceto tomografia'+#13#10+
            '8640206 - Servi�os de resson�ncia magn�tica'+#13#10+
            '8640207 - Servi�os de diagn�stico por imagem sem uso de radia��o ionizante, exceto resson�ncia magn�tica'+#13#10+
            '8640208 - Servi�os de diagn�stico por registro gr�fico - ECG, EEG e outros exames an�logos'+#13#10+
            '8640209 - Servi�os de diagn�stico por m�todos �pticos - endoscopia e outros exames an�logos'+#13#10+
            '8640210 - Servi�os de quimioterapia'+#13#10+
            '8640211 - Servi�os de radioterapia'+#13#10+
            '8640212 - Servi�os de hemoterapia'+#13#10+
            '8640213 - Servi�os de litotripsia'+#13#10+
            '8640214 - Servi�os de bancos de c�lulas e tecidos humanos'+#13#10+
            '8640299 - Atividades de servi�os de complementa��o diagn�stica e terap�utica n�o especificadas anteriormente'+#13#10+
            '8650001 - Atividades de enfermagem'+#13#10+
            '8650002 - Atividades de profissionais da nutri��o'+#13#10+
            '8650003 - Atividades de psicologia e psican�lise'+#13#10+
            '8650004 - Atividades de fisioterapia'+#13#10+
            '8650005 - Atividades de terapia ocupacional'+#13#10+
            '8650006 - Atividades de fonoaudiologia'+#13#10+
            '8650007 - Atividades de terapia de nutri��o enteral e parenteral'+#13#10+
            '8650099 - Atividades de profissionais da �rea de sa�de n�o especificadas anteriormente'+#13#10+
            '8660700 - Atividades de apoio � gest�o de sa�de'+#13#10+
            '8690901 - Atividades de pr�ticas integrativas e complementares em sa�de humana'+#13#10+
            '8690902 - Atividades de bancos de leite humano'+#13#10+
            '8690903 - Atividades de acupuntura'+#13#10+
            '8690904 - Atividades de podologia'+#13#10+
            '8690999 - Outras atividades de aten��o � sa�de humana n�o especificadas anteriormente'+#13#10+
            '8711501 - Cl�nicas e resid�ncias geri�tricas'+#13#10+
            '8711502 - Institui��es de longa perman�ncia para idosos'+#13#10+
            '8711503 - Atividades de assist�ncia a deficientes f�sicos, imunodeprimidos e convalescentes'+#13#10+
            '8711504 - Centros de apoio a pacientes com c�ncer e com AIDS'+#13#10+
            '8711505 - Condom�nios residenciais para idosos'+#13#10+
            '8712300 - Atividades de fornecimento de infraestrutura de apoio e assist�ncia a paciente no domic�lio'+#13#10+
            '8720401 - Atividades de centros de assist�ncia psicossocial'+#13#10+
            '8720499 - Atividades de assist�ncia psicossocial e � sa�de a portadores de dist�rbios ps�quicos, defici�ncia mental e depend�ncia qu�mica e grupos similares n�o especificadas anteriormente'+#13#10+
            '8730101 - Orfanatos'+#13#10+
            '8730102 - Albergues assistenciais'+#13#10+
            '8730199 - Atividades de assist�ncia social prestadas em resid�ncias coletivas e particulares n�o especificadas anteriormente'+#13#10+
            '8800600 - Servi�os de assist�ncia social sem alojamento'+#13#10+
            '9001901 - Produ��o teatral'+#13#10+
            '9001902 - Produ��o musical'+#13#10+
            '9001903 - Produ��o de espet�culos de dan�a'+#13#10+
            '9001904 - Produ��o de espet�culos circenses, de marionetes e similares'+#13#10+
            '9001905 - Produ��o de espet�culos de rodeios, vaquejadas e similares'+#13#10+
            '9001906 - Atividades de sonoriza��o e de ilumina��o'+#13#10+
            '9001999 - Artes c�nicas, espet�culos e atividades complementares n�o especificados anteriormente'+#13#10+
            '9002701 - Atividades de artistas pl�sticos, jornalistas independentes e escritores'+#13#10+
            '9002702 - Restaura��o de obras de arte'+#13#10+
            '9003500 - Gest�o de espa�os para artes c�nicas, espet�culos e outras atividades art�sticas'+#13#10+
            '9101500 - Atividades de bibliotecas e arquivos'+#13#10+
            '9102301 - Atividades de museus e de explora��o de lugares e pr�dios hist�ricos e atra��es similares'+#13#10+
            '9102302 - Restaura��o e conserva��o de lugares e pr�dios hist�ricos'+#13#10+
            '9103100 - Atividades de jardins bot�nicos, zool�gicos, parques nacionais, reservas ecol�gicas e �reas de prote��o ambiental'+#13#10+
            '9200301 - Casas de bingo'+#13#10+
            '9200302 - Explora��o de apostas em corridas de cavalos'+#13#10+
            '9200399 - Explora��o de jogos de azar e apostas n�o especificados anteriormente'+#13#10+
            '9311500 - Gest�o de instala��es de esportes'+#13#10+
            '9312300 - Clubes sociais, esportivos e similares'+#13#10+
            '9313100 - Atividades de condicionamento f�sico'+#13#10+
            '9319101 - Produ��o e promo��o de eventos esportivos'+#13#10+
            '9319199 - Outras atividades esportivas n�o especificadas anteriormente'+#13#10+
            '9321200 - Parques de divers�o e parques tem�ticos'+#13#10+
            '9329801 - Discotecas, danceterias, sal�es de dan�a e similares'+#13#10+
            '9329802 - Explora��o de boliches'+#13#10+
            '9329803 - Explora��o de jogos de sinuca, bilhar e similares'+#13#10+
            '9329804 - Explora��o de jogos eletr�nicos recreativos'+#13#10+
            '9329899 - Outras atividades de recrea��o e lazer n�o especificadas anteriormente'+#13#10+
            '9411100 - Atividades de organiza��es associativas patronais e empresariais'+#13#10+
            '9412001 - Atividades de fiscaliza��o profissional'+#13#10+
            '9412099 - Outras atividades associativas profissionais'+#13#10+
            '9420100 - Atividades de organiza��es sindicais'+#13#10+
            '9430800 - Atividades de associa��es de defesa de direitos sociais'+#13#10+
            '9491000 - Atividades de organiza��es religiosas ou filos�ficas'+#13#10+
            '9492800 - Atividades de organiza��es pol�ticas'+#13#10+
            '9493600 - Atividades de organiza��es associativas ligadas � cultura e � arte'+#13#10+
            '9499500 - Atividades associativas n�o especificadas anteriormente'+#13#10+
            '9511800 - Repara��o e manuten��o de computadores e de equipamentos perif�ricos'+#13#10+
            '9512600 - Repara��o e manuten��o de equipamentos de comunica��o'+#13#10+
            '9521500 - Repara��o e manuten��o de equipamentos eletroeletr�nicos de uso pessoal e dom�stico'+#13#10+
            '9529101 - Repara��o de cal�ados, bolsas e artigos de viagem'+#13#10+
            '9529102 - Chaveiros'+#13#10+
            '9529103 - Repara��o de rel�gios'+#13#10+
            '9529104 - Repara��o de bicicletas, triciclos e outros ve�culos n�o motorizados'+#13#10+
            '9529105 - Repara��o de artigos do mobili�rio'+#13#10+
            '9529106 - Repara��o de j�ias'+#13#10+
            '9529199 - Repara��o e manuten��o de outros objetos e equipamentos pessoais e dom�sticos n�o especificados anteriormente'+#13#10+
            '9601701 - Lavanderias'+#13#10+
            '9601702 - Tinturarias'+#13#10+
            '9601703 - Toalheiros'+#13#10+
            '9602501 - Cabeleireiros, manicure e pedicure'+#13#10+
            '9602502 - Atividades de est�tica e outros servi�os de cuidados com a beleza'+#13#10+
            '9603301 - Gest�o e manuten��o de cemit�rios'+#13#10+
            '9603302 - Servi�os de crema��o'+#13#10+
            '9603303 - Servi�os de sepultamento'+#13#10+
            '9603304 - Servi�os de funer�rias'+#13#10+
            '9603305 - Servi�os de somatoconserva��o'+#13#10+
            '9603399 - Atividades funer�rias e servi�os relacionados n�o especificados anteriormente'+#13#10+
            '9609202 - Ag�ncias matrimoniais'+#13#10+
            '9609204 - Explora��o de m�quinas de servi�os pessoais acionadas por moeda'+#13#10+
            '9609205 - Atividades de sauna e banhos'+#13#10+
            '9609206 - Servi�os de tatuagem e coloca��o de piercing'+#13#10+
            '9609207 - Alojamento de animais dom�sticos'+#13#10+
            '9609208 - Higiene e embelezamento de animais dom�sticos'+#13#10+
            '9609299 - Outras atividades de servi�os pessoais n�o especificadas anteriormente'+#13#10+
            '9700500 - Servi�os dom�sticos';
end;

end.
