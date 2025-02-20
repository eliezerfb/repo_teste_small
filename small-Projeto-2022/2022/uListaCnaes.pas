unit uListaCnaes;

interface

  function getListaCnae:string;

implementation

function getListaCnae:string;
begin
  Result := '0111301 - Cultivo de arroz'+#13#10+
            '0111302 - Cultivo de milho'+#13#10+
            '0111303 - Cultivo de trigo'+#13#10+
            '0111399 - Cultivo de outros cereais não especificados anteriormente'+#13#10+
            '0112101 - Cultivo de algodão herbáceo'+#13#10+
            '0112102 - Cultivo de juta'+#13#10+
            '0112199 - Cultivo de outras fibras de lavoura temporária não especificadas anteriormente'+#13#10+
            '0113000 - Cultivo de cana-de-açúcar'+#13#10+
            '0114800 - Cultivo de fumo'+#13#10+
            '0115600 - Cultivo de soja'+#13#10+
            '0116401 - Cultivo de amendoim'+#13#10+
            '0116402 - Cultivo de girassol'+#13#10+
            '0116403 - Cultivo de mamona'+#13#10+
            '0116499 - Cultivo de outras oleaginosas de lavoura temporária não especificadas anteriormente'+#13#10+
            '0119901 - Cultivo de abacaxi'+#13#10+
            '0119902 - Cultivo de alho'+#13#10+
            '0119903 - Cultivo de batata-inglesa'+#13#10+
            '0119904 - Cultivo de cebola'+#13#10+
            '0119905 - Cultivo de feijão'+#13#10+
            '0119906 - Cultivo de mandioca'+#13#10+
            '0119907 - Cultivo de melão'+#13#10+
            '0119908 - Cultivo de melancia'+#13#10+
            '0119909 - Cultivo de tomate rasteiro'+#13#10+
            '0119999 - Cultivo de outras plantas de lavoura temporária não especificadas anteriormente'+#13#10+
            '0121101 - Horticultura, exceto morango'+#13#10+
            '0121102 - Cultivo de morango'+#13#10+
            '0122900 - Cultivo de flores e plantas ornamentais'+#13#10+
            '0131800 - Cultivo de laranja'+#13#10+
            '0132600 - Cultivo de uva'+#13#10+
            '0133401 - Cultivo de açaí'+#13#10+
            '0133402 - Cultivo de banana'+#13#10+
            '0133403 - Cultivo de caju'+#13#10+
            '0133404 - Cultivo de cítricos, exceto laranja'+#13#10+
            '0133405 - Cultivo de coco-da-baía'+#13#10+
            '0133406 - Cultivo de guaraná'+#13#10+
            '0133407 - Cultivo de maçã'+#13#10+
            '0133408 - Cultivo de mamão'+#13#10+
            '0133409 - Cultivo de maracujá'+#13#10+
            '0133410 - Cultivo de manga'+#13#10+
            '0133411 - Cultivo de pêssego'+#13#10+
            '0133499 - Cultivo de frutas de lavoura permanente não especificadas anteriormente'+#13#10+
            '0134200 - Cultivo de café'+#13#10+
            '0135100 - Cultivo de cacau'+#13#10+
            '0139301 - Cultivo de chá-da-índia'+#13#10+
            '0139302 - Cultivo de erva-mate'+#13#10+
            '0139303 - Cultivo de pimenta-do-reino'+#13#10+
            '0139304 - Cultivo de plantas para condimento, exceto pimenta-do-reino'+#13#10+
            '0139305 - Cultivo de dendê'+#13#10+
            '0139306 - Cultivo de seringueira'+#13#10+
            '0139399 - Cultivo de outras plantas de lavoura permanente não especificadas anteriormente'+#13#10+
            '0141501 - Produção de sementes certificadas, exceto de forrageiras para pasto'+#13#10+
            '0141502 - Produção de sementes certificadas de forrageiras para formação de pasto'+#13#10+
            '0142300 - Produção de mudas e outras formas de propagação vegetal, certificadas'+#13#10+
            '0151201 - Criação de bovinos para corte'+#13#10+
            '0151202 - Criação de bovinos para leite'+#13#10+
            '0151203 - Criação de bovinos, exceto para corte e leite'+#13#10+
            '0152101 - Criação de bufalinos'+#13#10+
            '0152102 - Criação de equinos'+#13#10+
            '0152103 - Criação de asininos e muares'+#13#10+
            '0153901 - Criação de caprinos'+#13#10+
            '0153902 - Criação de ovinos, inclusive para produção de lã'+#13#10+
            '0154700 - Criação de suínos'+#13#10+
            '0155501 - Criação de frangos para corte'+#13#10+
            '0155502 - Produção de pintos de um dia'+#13#10+
            '0155503 - Criação de outros galináceos, exceto para corte'+#13#10+
            '0155504 - Criação de aves, exceto galináceos'+#13#10+
            '0155505 - Produção de ovos'+#13#10+
            '0159801 - Apicultura'+#13#10+
            '0159802 - Criação de animais de estimação'+#13#10+
            '0159803 - Criação de escargô'+#13#10+
            '0159804 - Criação de bicho-da-seda'+#13#10+
            '0159899 - Criação de outros animais não especificados anteriormente'+#13#10+
            '0161001 - Serviço de pulverização e controle de pragas agrícolas'+#13#10+
            '0161002 - Serviço de poda de árvores para lavouras'+#13#10+
            '0161003 - Serviço de preparação de terreno, cultivo e colheita'+#13#10+
            '0161099 - Atividades de apoio à agricultura não especificadas anteriormente'+#13#10+
            '0162801 - Serviço de inseminação artificial em animais'+#13#10+
            '0162802 - Serviço de tosquiamento de ovinos'+#13#10+
            '0162803 - Serviço de manejo de animais'+#13#10+
            '0162899 - Atividades de apoio à pecuária não especificadas anteriormente'+#13#10+
            '0163600 - Atividades de pós-colheita'+#13#10+
            '0170900 - Caça e serviços relacionados'+#13#10+
            '0210101 - Cultivo de eucalipto'+#13#10+
            '0210102 - Cultivo de acácia-negra'+#13#10+
            '0210103 - Cultivo de pinus'+#13#10+
            '0210104 - Cultivo de teca'+#13#10+
            '0210105 - Cultivo de espécies madeireiras, exceto eucalipto, acácia-negra, pinus e teca'+#13#10+
            '0210106 - Cultivo de mudas em viveiros florestais'+#13#10+
            '0210107 - Extração de madeira em florestas plantadas'+#13#10+
            '0210108 - Produção de carvão vegetal - florestas plantadas'+#13#10+
            '0210109 - Produção de casca de acácia-negra - florestas plantadas'+#13#10+
            '0210199 - Produção de produtos não madeireiros não especificados anteriormente em florestas plantadas'+#13#10+
            '0220901 - Extração de madeira em florestas nativas'+#13#10+
            '0220902 - Produção de carvão vegetal - florestas nativas'+#13#10+
            '0220903 - Coleta de castanha-do-pará em florestas nativas'+#13#10+
            '0220904 - Coleta de látex em florestas nativas'+#13#10+
            '0220905 - Coleta de palmito em florestas nativas'+#13#10+
            '0220906 - Conservação de florestas nativas'+#13#10+
            '0220999 - Coleta de produtos não madeireiros não especificados anteriormente em florestas nativas'+#13#10+
            '0230600 - Atividades de apoio à produção florestal'+#13#10+
            '0311601 - Pesca de peixes em água salgada'+#13#10+
            '0311602 - Pesca de crustáceos e moluscos em água salgada'+#13#10+
            '0311603 - Coleta de outros produtos marinhos'+#13#10+
            '0311604 - Atividades de apoio à pesca em água salgada'+#13#10+
            '0312401 - Pesca de peixes em água doce'+#13#10+
            '0312402 - Pesca de crustáceos e moluscos em água doce'+#13#10+
            '0312403 - Coleta de outros produtos aquáticos de água doce'+#13#10+
            '0312404 - Atividades de apoio à pesca em água doce'+#13#10+
            '0321301 - Criação de peixes em água salgada e salobra'+#13#10+
            '0321302 - Criação de camarões em água salgada e salobra'+#13#10+
            '0321303 - Criação de ostras e mexilhões em água salgada e salobra'+#13#10+
            '0321304 - Criação de peixes ornamentais em água salgada e salobra'+#13#10+
            '0321305 - Atividades de apoio à aquicultura em água salgada e salobra'+#13#10+
            '0321399 - Cultivos e semicultivos da aquicultura em água salgada e salobra não especificados anteriormente'+#13#10+
            '0322101 - Criação de peixes em água doce'+#13#10+
            '0322102 - Criação de camarões em água doce'+#13#10+
            '0322103 - Criação de ostras e mexilhões em água doce'+#13#10+
            '0322104 - Criação de peixes ornamentais em água doce'+#13#10+
            '0322105 - Ranicultura'+#13#10+
            '0322106 - Criação de jacaré'+#13#10+
            '0322107 - Atividades de apoio à aquicultura em água doce'+#13#10+
            '0322199 - Cultivos e semicultivos da aquicultura em água doce não especificados anteriormente'+#13#10+
            '0500301 - Extração de carvão mineral'+#13#10+
            '0500302 - Beneficiamento de carvão mineral'+#13#10+
            '0600001 - Extração de petróleo e gás natural'+#13#10+
            '0600002 - Extração e beneficiamento de xisto'+#13#10+
            '0600003 - Extração e beneficiamento de areias betuminosas'+#13#10+
            '0710301 - Extração de minério de ferro'+#13#10+
            '0710302 - Pelotização, sinterização e outros beneficiamentos de minério de ferro'+#13#10+
            '0721901 - Extração de minério de alumínio'+#13#10+
            '0721902 - Beneficiamento de minério de alumínio'+#13#10+
            '0722701 - Extração de minério de estanho'+#13#10+
            '0722702 - Beneficiamento de minério de estanho'+#13#10+
            '0723501 - Extração de minério de manganês'+#13#10+
            '0723502 - Beneficiamento de minério de manganês'+#13#10+
            '0724301 - Extração de minério de metais preciosos'+#13#10+
            '0724302 - Beneficiamento de minério de metais preciosos'+#13#10+
            '0725100 - Extração de minerais radioativos'+#13#10+
            '0729401 - Extração de minérios de nióbio e titânio'+#13#10+
            '0729402 - Extração de minério de tungstênio'+#13#10+
            '0729403 - Extração de minério de níquel'+#13#10+
            '0729404 - Extração de minérios de cobre, chumbo, zinco e outros minerais metálicos não ferrosos não especificados anteriormente'+#13#10+
            '0729405 - Beneficiamento de minérios de cobre, chumbo, zinco e outros minerais metálicos não ferrosos não especificados anteriormente'+#13#10+
            '0810001 - Extração de ardósia e beneficiamento associado'+#13#10+
            '0810002 - Extração de granito e beneficiamento associado'+#13#10+
            '0810003 - Extração de mármore e beneficiamento associado'+#13#10+
            '0810004 - Extração de calcário e dolomita e beneficiamento associado'+#13#10+
            '0810005 - Extração de gesso e caulim'+#13#10+
            '0810006 - Extração de areia, cascalho ou pedregulho e beneficiamento associado'+#13#10+
            '0810007 - Extração de argila e beneficiamento associado'+#13#10+
            '0810008 - Extração de saibro e beneficiamento associado'+#13#10+
            '0810009 - Extração de basalto e beneficiamento associado'+#13#10+
            '0810010 - Beneficiamento de gesso e caulim associado à extração'+#13#10+
            '0810099 - Extração e britamento de pedras e outros materiais para construção e beneficiamento associado'+#13#10+
            '0891600 - Extração de minerais para fabricação de adubos, fertilizantes e outros produtos químicos'+#13#10+
            '0892401 - Extração de sal marinho'+#13#10+
            '0892402 - Extração de sal-gema'+#13#10+
            '0892403 - Refino e outros tratamentos do sal'+#13#10+
            '0893200 - Extração de gemas (pedras preciosas e semipreciosas)'+#13#10+
            '0899101 - Extração de grafita'+#13#10+
            '0899102 - Extração de quartzo'+#13#10+
            '0899103 - Extração de amianto'+#13#10+
            '0899199 - Extração de outros minerais não metálicos não especificados anteriormente'+#13#10+
            '0910600 - Atividades de apoio à extração de petróleo e gás natural'+#13#10+
            '0990401 - Atividades de apoio à extração de minério de ferro'+#13#10+
            '0990402 - Atividades de apoio à extração de minerais metálicos não ferrosos'+#13#10+
            '0990403 - Atividades de apoio à extração de minerais não metálicos'+#13#10+
            '1011201 - Frigorífico - abate de bovinos'+#13#10+
            '1011202 - Frigorífico - abate de equinos'+#13#10+
            '1011203 - Frigorífico - abate de ovinos e caprinos'+#13#10+
            '1011204 - Frigorífico - abate de bufalinos'+#13#10+
            '1011205 - Matadouro - abate de reses sob contrato, exceto abate de suínos'+#13#10+
            '1012101 - Abate de aves'+#13#10+
            '1012102 - Abate de pequenos animais'+#13#10+
            '1012103 - Frigorífico - abate de suínos'+#13#10+
            '1012104 - Matadouro - abate de suínos sob contrato'+#13#10+
            '1013901 - Fabricação de produtos de carne'+#13#10+
            '1013902 - Preparação de subprodutos do abate'+#13#10+
            '1020101 - Preservação de peixes, crustáceos e moluscos'+#13#10+
            '1020102 - Fabricação de conservas de peixes, crustáceos e moluscos'+#13#10+
            '1031700 - Fabricação de conservas de frutas'+#13#10+
            '1032501 - Fabricação de conservas de palmito'+#13#10+
            '1032599 - Fabricação de conservas de legumes e outros vegetais, exceto palmito'+#13#10+
            '1033301 - Fabricação de sucos concentrados de frutas, hortaliças e legumes'+#13#10+
            '1033302 - Fabricação de sucos de frutas, hortaliças e legumes, exceto concentrados'+#13#10+
            '1041400 - Fabricação de óleos vegetais em bruto, exceto óleo de milho'+#13#10+
            '1042200 - Fabricação de óleos vegetais refinados, exceto óleo de milho'+#13#10+
            '1043100 - Fabricação de margarina e outras gorduras vegetais e de óleos não comestíveis de animais'+#13#10+
            '1051100 - Preparação do leite'+#13#10+
            '1052000 - Fabricação de laticínios'+#13#10+
            '1053800 - Fabricação de sorvetes e outros gelados comestíveis'+#13#10+
            '1061901 - Beneficiamento de arroz'+#13#10+
            '1061902 - Fabricação de produtos do arroz'+#13#10+
            '1062700 - Moagem de trigo e fabricação de derivados'+#13#10+
            '1063500 - Fabricação de farinha de mandioca e derivados'+#13#10+
            '1064300 - Fabricação de farinha de milho e derivados, exceto óleos de milho'+#13#10+
            '1065101 - Fabricação de amidos e féculas de vegetais'+#13#10+
            '1065102 - Fabricação de óleo de milho em bruto'+#13#10+
            '1065103 - Fabricação de óleo de milho refinado'+#13#10+
            '1066000 - Fabricação de alimentos para animais'+#13#10+
            '1069400 - Moagem e fabricação de produtos de origem vegetal não especificados anteriormente'+#13#10+
            '1071600 - Fabricação de açúcar em bruto'+#13#10+
            '1072401 - Fabricação de açúcar de cana refinado'+#13#10+
            '1072402 - Fabricação de açúcar de cereais (dextrose) e de beterraba'+#13#10+
            '1081301 - Beneficiamento de café'+#13#10+
            '1081302 - Torrefação e moagem de café'+#13#10+
            '1082100 - Fabricação de produtos à base de café'+#13#10+
            '1091101 - Fabricação de produtos de panificação industrial'+#13#10+
            '1091102 - Fabricação de produtos de padaria e confeitaria com predominância de produção própria'+#13#10+
            '1092900 - Fabricação de biscoitos e bolachas'+#13#10+
            '1093701 - Fabricação de produtos derivados do cacau e de chocolates'+#13#10+
            '1093702 - Fabricação de frutas cristalizadas, balas e semelhantes'+#13#10+
            '1094500 - Fabricação de massas alimentícias'+#13#10+
            '1095300 - Fabricação de especiarias, molhos, temperos e condimentos'+#13#10+
            '1096100 - Fabricação de alimentos e pratos prontos'+#13#10+
            '1099601 - Fabricação de vinagres'+#13#10+
            '1099602 - Fabricação de pós-alimentícios'+#13#10+
            '1099603 - Fabricação de fermentos e leveduras'+#13#10+
            '1099604 - Fabricação de gelo comum'+#13#10+
            '1099605 - Fabricação de produtos para infusão (chá, mate, etc.)'+#13#10+
            '1099606 - Fabricação de adoçantes naturais e artificiais'+#13#10+
            '1099607 - Fabricação de alimentos dietéticos e complementos alimentares'+#13#10+
            '1099699 - Fabricação de outros produtos alimentícios não especificados anteriormente'+#13#10+
            '1111901 - Fabricação de aguardente de cana-de-açúcar'+#13#10+
            '1111902 - Fabricação de outras aguardentes e bebidas destiladas'+#13#10+
            '1112700 - Fabricação de vinho'+#13#10+
            '1113501 - Fabricação de malte, inclusive malte uísque'+#13#10+
            '1113502 - Fabricação de cervejas e chopes'+#13#10+
            '1121600 - Fabricação de águas envasadas'+#13#10+
            '1122401 - Fabricação de refrigerantes'+#13#10+
            '1122402 - Fabricação de chá mate e outros chás prontos para consumo'+#13#10+
            '1122403 - Fabricação de refrescos, xaropes e pós para refrescos, exceto refrescos de frutas'+#13#10+
            '1122404 - Fabricação de bebidas isotônicas'+#13#10+
            '1122499 - Fabricação de outras bebidas não alcoólicas não especificadas anteriormente'+#13#10+
            '1210700 - Processamento industrial do fumo'+#13#10+
            '1220401 - Fabricação de cigarros'+#13#10+
            '1220402 - Fabricação de cigarrilhas e charutos'+#13#10+
            '1220403 - Fabricação de filtros para cigarros'+#13#10+
            '1220499 - Fabricação de outros produtos do fumo, exceto cigarros, cigarrilhas e charutos'+#13#10+
            '1311100 - Preparação e fiação de fibras de algodão'+#13#10+
            '1312000 - Preparação e fiação de fibras têxteis naturais, exceto algodão'+#13#10+
            '1313800 - Fiação de fibras artificiais e sintéticas'+#13#10+
            '1314600 - Fabricação de linhas para costurar e bordar'+#13#10+
            '1321900 - Tecelagem de fios de algodão'+#13#10+
            '1322700 - Tecelagem de fios de fibras têxteis naturais, exceto algodão'+#13#10+
            '1323500 - Tecelagem de fios de fibras artificiais e sintéticas'+#13#10+
            '1330800 - Fabricação de tecidos de malha'+#13#10+
            '1340501 - Estamparia e texturização em fios, tecidos, artefatos têxteis e peças do vestuário'+#13#10+
            '1340502 - Alvejamento, tingimento e torção em fios, tecidos, artefatos têxteis e peças do vestuário'+#13#10+
            '1340599 - Outros serviços de acabamento em fios, tecidos, artefatos têxteis e peças do vestuário'+#13#10+
            '1351100 - Fabricação de artefatos têxteis para uso doméstico'+#13#10+
            '1352900 - Fabricação de artefatos de tapeçaria'+#13#10+
            '1353700 - Fabricação de artefatos de cordoaria'+#13#10+
            '1354500 - Fabricação de tecidos especiais, inclusive artefatos'+#13#10+
            '1359600 - Fabricação de outros produtos têxteis não especificados anteriormente'+#13#10+
            '1411801 - Confecção de roupas íntimas'+#13#10+
            '1411802 - Facção de roupas íntimas'+#13#10+
            '1412601 - Confecção de peças do vestuário, exceto roupas íntimas e as confeccionadas sob medida'+#13#10+
            '1412602 - Confecção, sob medida, de peças do vestuário, exceto roupas íntimas'+#13#10+
            '1412603 - Facção de peças do vestuário, exceto roupas íntimas'+#13#10+
            '1413401 - Confecção de roupas profissionais, exceto sob medida'+#13#10+
            '1413402 - Confecção, sob medida, de roupas profissionais'+#13#10+
            '1413403 - Facção de roupas profissionais'+#13#10+
            '1414200 - Fabricação de acessórios do vestuário, exceto para segurança e proteção'+#13#10+
            '1421500 - Fabricação de meias'+#13#10+
            '1422300 - Fabricação de artigos do vestuário, produzidos em malharias e tricotagens, exceto meias'+#13#10+
            '1510600 - Curtimento e outras preparações de couro'+#13#10+
            '1521100 - Fabricação de artigos para viagem, bolsas e semelhantes de qualquer material'+#13#10+
            '1529700 - Fabricação de artefatos de couro não especificados anteriormente'+#13#10+
            '1531901 - Fabricação de calçados de couro'+#13#10+
            '1531902 - Acabamento de calçados de couro sob contrato'+#13#10+
            '1532700 - Fabricação de tênis de qualquer material'+#13#10+
            '1533500 - Fabricação de calçados de material sintético'+#13#10+
            '1539400 - Fabricação de calçados de materiais não especificados anteriormente'+#13#10+
            '1540800 - Fabricação de partes para calçados, de qualquer material'+#13#10+
            '1610203 - Serrarias com desdobramento de madeira em bruto'+#13#10+
            '1610204 - Serrarias sem desdobramento de madeira em bruto - Resseragem'+#13#10+
            '1610205 - Serviço de tratamento de madeira realizado sob contrato'+#13#10+
            '1621800 - Fabricação de madeira laminada e de chapas de madeira compensada, prensada e aglomerada'+#13#10+
            '1622601 - Fabricação de casas de madeira pré-fabricadas'+#13#10+
            '1622602 - Fabricação de esquadrias de madeira e de peças de madeira para instalações industriais e comerciais'+#13#10+
            '1622699 - Fabricação de outros artigos de carpintaria para construção'+#13#10+
            '1623400 - Fabricação de artefatos de tanoaria e de embalagens de madeira'+#13#10+
            '1629301 - Fabricação de artefatos diversos de madeira, exceto móveis'+#13#10+
            '1629302 - Fabricação de artefatos diversos de cortiça, bambu, palha, vime e outros materiais trançados, exceto móveis'+#13#10+
            '1710900 - Fabricação de celulose e outras pastas para a fabricação de papel'+#13#10+
            '1721400 - Fabricação de papel'+#13#10+
            '1722200 - Fabricação de cartolina e papel-cartão'+#13#10+
            '1731100 - Fabricação de embalagens de papel'+#13#10+
            '1732000 - Fabricação de embalagens de cartolina e papel-cartão'+#13#10+
            '1733800 - Fabricação de chapas e de embalagens de papelão ondulado'+#13#10+
            '1741901 - Fabricação de formulários contínuos'+#13#10+
            '1741902 - Fabricação de produtos de papel, cartolina, papel-cartão e papelão ondulado para uso comercial e de escritório'+#13#10+
            '1742701 - Fabricação de fraldas descartáveis'+#13#10+
            '1742702 - Fabricação de absorventes higiênicos'+#13#10+
            '1742799 - Fabricação de produtos de papel para uso doméstico e higiênico-sanitário não especificados anteriormente'+#13#10+
            '1749400 - Fabricação de produtos de pastas celulósicas, papel, cartolina, papel-cartão e papelão ondulado não especificados anteriormente'+#13#10+
            '1811301 - Impressão de jornais'+#13#10+
            '1811302 - Impressão de livros, revistas e outras publicações periódicas'+#13#10+
            '1812100 - Impressão de material de segurança'+#13#10+
            '1813001 - Impressão de material para uso publicitário'+#13#10+
            '1813099 - Impressão de material para outros usos'+#13#10+
            '1821100 - Serviços de pré-impressão'+#13#10+
            '1822901 - Serviços de encadernação e plastificação'+#13#10+
            '1822999 - Serviços de acabamentos gráficos, exceto encadernação e plastificação'+#13#10+
            '1830001 - Reprodução de som em qualquer suporte'+#13#10+
            '1830002 - Reprodução de vídeo em qualquer suporte'+#13#10+
            '1830003 - Reprodução de software em qualquer suporte'+#13#10+
            '1910100 - Coquerias'+#13#10+
            '1921700 - Fabricação de produtos do refino de petróleo'+#13#10+
            '1922501 - Formulação de combustíveis'+#13#10+
            '1922502 - Rerrefino de óleos lubrificantes'+#13#10+
            '1922599 - Fabricação de outros produtos derivados do petróleo, exceto produtos do refino'+#13#10+
            '1931400 - Fabricação de álcool'+#13#10+
            '1932200 - Fabricação de biocombustíveis, exceto álcool'+#13#10+
            '2011800 - Fabricação de cloro e álcalis'+#13#10+
            '2012600 - Fabricação de intermediários para fertilizantes'+#13#10+
            '2013401 - Fabricação de adubos e fertilizantes organo-minerais'+#13#10+
            '2013402 - Fabricação de adubos e fertilizantes, exceto organo-minerais'+#13#10+
            '2014200 - Fabricação de gases industriais'+#13#10+
            '2019301 - Elaboração de combustíveis nucleares'+#13#10+
            '2019399 - Fabricação de outros produtos químicos inorgânicos não especificados anteriormente'+#13#10+
            '2021500 - Fabricação de produtos petroquímicos básicos'+#13#10+
            '2022300 - Fabricação de intermediários para plastificantes, resinas e fibras'+#13#10+
            '2029100 - Fabricação de produtos químicos orgânicos não especificados anteriormente'+#13#10+
            '2031200 - Fabricação de resinas termoplásticas'+#13#10+
            '2032100 - Fabricação de resinas termofixas'+#13#10+
            '2033900 - Fabricação de elastômeros'+#13#10+
            '2040100 - Fabricação de fibras artificiais e sintéticas'+#13#10+
            '2051700 - Fabricação de defensivos agrícolas'+#13#10+
            '2052500 - Fabricação de desinfestantes domissanitários'+#13#10+
            '2061400 - Fabricação de sabões e detergentes sintéticos'+#13#10+
            '2062200 - Fabricação de produtos de limpeza e polimento'+#13#10+
            '2063100 - Fabricação de cosméticos, produtos de perfumaria e de higiene pessoal'+#13#10+
            '2071100 - Fabricação de tintas, vernizes, esmaltes e lacas'+#13#10+
            '2072000 - Fabricação de tintas de impressão'+#13#10+
            '2073800 - Fabricação de impermeabilizantes, solventes e produtos afins'+#13#10+
            '2091600 - Fabricação de adesivos e selantes'+#13#10+
            '2092401 - Fabricação de pólvoras, explosivos e detonantes'+#13#10+
            '2092402 - Fabricação de artigos pirotécnicos'+#13#10+
            '2092403 - Fabricação de fósforos de segurança'+#13#10+
            '2093200 - Fabricação de aditivos de uso industrial'+#13#10+
            '2094100 - Fabricação de catalisadores'+#13#10+
            '2099101 - Fabricação de chapas, filmes, papéis e outros materiais e produtos químicos para fotografia'+#13#10+
            '2099199 - Fabricação de outros produtos químicos não especificados anteriormente'+#13#10+
            '2110600 - Fabricação de produtos farmoquímicos'+#13#10+
            '2121101 - Fabricação de medicamentos alopáticos para uso humano'+#13#10+
            '2121102 - Fabricação de medicamentos homeopáticos para uso humano'+#13#10+
            '2121103 - Fabricação de medicamentos fitoterápicos para uso humano'+#13#10+
            '2122000 - Fabricação de medicamentos para uso veterinário'+#13#10+
            '2123800 - Fabricação de preparações farmacêuticas'+#13#10+
            '2211100 - Fabricação de pneumáticos e de câmaras-de-ar'+#13#10+
            '2212900 - Reforma de pneumáticos usados'+#13#10+
            '2219600 - Fabricação de artefatos de borracha não especificados anteriormente'+#13#10+
            '2221800 - Fabricação de laminados planos e tubulares de material plástico'+#13#10+
            '2222600 - Fabricação de embalagens de material plástico'+#13#10+
            '2223400 - Fabricação de tubos e acessórios de material plástico para uso na construção'+#13#10+
            '2229301 - Fabricação de artefatos de material plástico para uso pessoal e doméstico'+#13#10+
            '2229302 - Fabricação de artefatos de material plástico para usos industriais'+#13#10+
            '2229303 - Fabricação de artefatos de material plástico para uso na construção, exceto tubos e acessórios'+#13#10+
            '2229399 - Fabricação de artefatos de material plástico para outros usos não especificados anteriormente'+#13#10+
            '2311700 - Fabricação de vidro plano e de segurança'+#13#10+
            '2312500 - Fabricação de embalagens de vidro'+#13#10+
            '2319200 - Fabricação de artigos de vidro'+#13#10+
            '2320600 - Fabricação de cimento'+#13#10+
            '2330301 - Fabricação de estruturas pré-moldadas de concreto armado, em série e sob encomenda'+#13#10+
            '2330302 - Fabricação de artefatos de cimento para uso na construção'+#13#10+
            '2330303 - Fabricação de artefatos de fibrocimento para uso na construção'+#13#10+
            '2330304 - Fabricação de casas pré-moldadas de concreto'+#13#10+
            '2330305 - Preparação de massa de concreto e argamassa para construção'+#13#10+
            '2330399 - Fabricação de outros artefatos e produtos de concreto, cimento, fibrocimento, gesso e materiais semelhantes'+#13#10+
            '2341900 - Fabricação de produtos cerâmicos refratários'+#13#10+
            '2342701 - Fabricação de azulejos e pisos'+#13#10+
            '2342702 - Fabricação de artefatos de cerâmica e barro cozido para uso na construção, exceto azulejos e pisos'+#13#10+
            '2349401 - Fabricação de material sanitário de cerâmica'+#13#10+
            '2349499 - Fabricação de produtos cerâmicos não refratários não especificados anteriormente'+#13#10+
            '2391501 - Britamento de pedras, exceto associado à extração'+#13#10+
            '2391502 - Aparelhamento de pedras para construção, exceto associado à extração'+#13#10+
            '2391503 - Aparelhamento de placas e execução de trabalhos em mármore, granito, ardósia e outras pedras'+#13#10+
            '2392300 - Fabricação de cal e gesso'+#13#10+
            '2399101 - Decoração, lapidação, gravação, vitrificação e outros trabalhos em cerâmica, louça, vidro e cristal'+#13#10+
            '2399102 - Fabricação de abrasivos'+#13#10+
            '2399199 - Fabricação de outros produtos de minerais não metálicos não especificados anteriormente'+#13#10+
            '2411300 - Produção de ferro-gusa'+#13#10+
            '2412100 - Produção de ferroligas'+#13#10+
            '2421100 - Produção de semiacabados de aço'+#13#10+
            '2422901 - Produção de laminados planos de aço ao carbono, revestidos ou não'+#13#10+
            '2422902 - Produção de laminados planos de aços especiais'+#13#10+
            '2423701 - Produção de tubos de aço sem costura'+#13#10+
            '2423702 - Produção de laminados longos de aço, exceto tubos'+#13#10+
            '2424501 - Produção de arames de aço'+#13#10+
            '2424502 - Produção de relaminados, trefilados e perfilados de aço, exceto arames'+#13#10+
            '2431800 - Produção de tubos de aço com costura'+#13#10+
            '2439300 - Produção de outros tubos de ferro e aço'+#13#10+
            '2441501 - Produção de alumínio e suas ligas em formas primárias'+#13#10+
            '2441502 - Produção de laminados de alumínio'+#13#10+
            '2442300 - Metalurgia dos metais preciosos'+#13#10+
            '2443100 - Metalurgia do cobre'+#13#10+
            '2449101 - Produção de zinco em formas primárias'+#13#10+
            '2449102 - Produção de laminados de zinco'+#13#10+
            '2449103 - Fabricação de ânodos para galvanoplastia'+#13#10+
            '2449199 - Metalurgia de outros metais não ferrosos e suas ligas não especificados anteriormente'+#13#10+
            '2451200 - Fundição de ferro e aço'+#13#10+
            '2452100 - Fundição de metais não ferrosos e suas ligas'+#13#10+
            '2511000 - Fabricação de estruturas metálicas'+#13#10+
            '2512800 - Fabricação de esquadrias de metal'+#13#10+
            '2513600 - Fabricação de obras de caldeiraria pesada'+#13#10+
            '2521700 - Fabricação de tanques, reservatórios metálicos e caldeiras para aquecimento central'+#13#10+
            '2522500 - Fabricação de caldeiras geradoras de vapor, exceto para aquecimento central e para veículos'+#13#10+
            '2531401 - Produção de forjados de aço'+#13#10+
            '2531402 - Produção de forjados de metais não ferrosos e suas ligas'+#13#10+
            '2532201 - Produção de artefatos estampados de metal'+#13#10+
            '2532202 - Metalurgia do pó'+#13#10+
            '2539001 - Serviços de usinagem, torneiria e solda'+#13#10+
            '2539002 - Serviços de tratamento e revestimento em metais'+#13#10+
            '2541100 - Fabricação de artigos de cutelaria'+#13#10+
            '2542000 - Fabricação de artigos de serralheria, exceto esquadrias'+#13#10+
            '2543800 - Fabricação de ferramentas'+#13#10+
            '2550101 - Fabricação de equipamento bélico pesado, exceto veículos militares de combate'+#13#10+
            '2550102 - Fabricação de armas de fogo, outras armas e munições'+#13#10+
            '2591800 - Fabricação de embalagens metálicas'+#13#10+
            '2592601 - Fabricação de produtos de trefilados de metal padronizados'+#13#10+
            '2592602 - Fabricação de produtos de trefilados de metal, exceto padronizados'+#13#10+
            '2593400 - Fabricação de artigos de metal para uso doméstico e pessoal'+#13#10+
            '2599301 - Serviços de confecção de armações metálicas para a construção'+#13#10+
            '2599302 - Serviço de corte e dobra de metais'+#13#10+
            '2599399 - Fabricação de outros produtos de metal não especificados anteriormente'+#13#10+
            '2610800 - Fabricação de componentes eletrônicos'+#13#10+
            '2621300 - Fabricação de equipamentos de informática'+#13#10+
            '2622100 - Fabricação de periféricos para equipamentos de informática'+#13#10+
            '2631100 - Fabricação de equipamentos transmissores de comunicação, peças e acessórios'+#13#10+
            '2632900 - Fabricação de aparelhos telefônicos e de outros equipamentos de comunicação, peças e acessórios'+#13#10+
            '2640000 - Fabricação de aparelhos de recepção, reprodução, gravação e amplificação de áudio e vídeo'+#13#10+
            '2651500 - Fabricação de aparelhos e equipamentos de medida, teste e controle'+#13#10+
            '2652300 - Fabricação de cronômetros e relógios'+#13#10+
            '2660400 - Fabricação de aparelhos eletromédicos e eletroterapêuticos e equipamentos de irradiação'+#13#10+
            '2670101 - Fabricação de equipamentos e instrumentos ópticos, peças e acessórios'+#13#10+
            '2670102 - Fabricação de aparelhos fotográficos e cinematográficos, peças e acessórios'+#13#10+
            '2680900 - Fabricação de mídias virgens, magnéticas e ópticas'+#13#10+
            '2710401 - Fabricação de geradores de corrente contínua e alternada, peças e acessórios'+#13#10+
            '2710402 - Fabricação de transformadores, indutores, conversores, sincronizadores e semelhantes, peças e acessórios'+#13#10+
            '2710403 - Fabricação de motores elétricos, peças e acessórios'+#13#10+
            '2721000 - Fabricação de pilhas, baterias e acumuladores elétricos, exceto para veículos automotores'+#13#10+
            '2722801 - Fabricação de baterias e acumuladores para veículos automotores'+#13#10+
            '2722802 - Recondicionamento de baterias e acumuladores para veículos automotores'+#13#10+
            '2731700 - Fabricação de aparelhos e equipamentos para distribuição e controle de energia elétrica'+#13#10+
            '2732500 - Fabricação de material elétrico para instalações em circuito de consumo'+#13#10+
            '2733300 - Fabricação de fios, cabos e condutores elétricos isolados'+#13#10+
            '2740601 - Fabricação de lâmpadas'+#13#10+
            '2740602 - Fabricação de luminárias e outros equipamentos de iluminação'+#13#10+
            '2751100 - Fabricação de fogões, refrigeradores e máquinas de lavar e secar para uso doméstico, peças e acessórios'+#13#10+
            '2759701 - Fabricação de aparelhos elétricos de uso pessoal, peças e acessórios'+#13#10+
            '2759799 - Fabricação de outros aparelhos eletrodomésticos não especificados anteriormente, peças e acessórios'+#13#10+
            '2790201 - Fabricação de eletrodos, contatos e outros artigos de carvão e grafita para uso elétrico, eletroímãs e isoladores'+#13#10+
            '2790202 - Fabricação de equipamentos para sinalização e alarme'+#13#10+
            '2790299 - Fabricação de outros equipamentos e aparelhos elétricos não especificados anteriormente'+#13#10+
            '2811900 - Fabricação de motores e turbinas, peças e acessórios, exceto para aviões e veículos rodoviários'+#13#10+
            '2812700 - Fabricação de equipamentos hidráulicos e pneumáticos, peças e acessórios, exceto válvulas'+#13#10+
            '2813500 - Fabricação de válvulas, registros e dispositivos semelhantes, peças e acessórios'+#13#10+
            '2814301 - Fabricação de compressores para uso industrial, peças e acessórios'+#13#10+
            '2814302 - Fabricação de compressores para uso não industrial, peças e acessórios'+#13#10+
            '2815101 - Fabricação de rolamentos para fins industriais'+#13#10+
            '2815102 - Fabricação de equipamentos de transmissão para fins industriais, exceto rolamentos'+#13#10+
            '2821601 - Fabricação de fornos industriais, aparelhos e equipamentos não elétricos para instalações térmicas, peças e acessórios'+#13#10+
            '2821602 - Fabricação de estufas e fornos elétricos para fins industriais, peças e acessórios'+#13#10+
            '2822401 - Fabricação de máquinas, equipamentos e aparelhos para transporte e elevação de pessoas, peças e acessórios'+#13#10+
            '2822402 - Fabricação de máquinas, equipamentos e aparelhos para transporte e elevação de cargas, peças e acessórios'+#13#10+
            '2823200 - Fabricação de máquinas e aparelhos de refrigeração e ventilação para uso industrial e comercial, peças e acessórios'+#13#10+
            '2824101 - Fabricação de aparelhos e equipamentos de ar condicionado para uso industrial'+#13#10+
            '2824102 - Fabricação de aparelhos e equipamentos de ar condicionado para uso não industrial'+#13#10+
            '2825900 - Fabricação de máquinas e equipamentos para saneamento básico e ambiental, peças e acessórios'+#13#10+
            '2829101 - Fabricação de máquinas de escrever, calcular e outros equipamentos não eletrônicos para escritório, peças e acessórios'+#13#10+
            '2829199 - Fabricação de outras máquinas e equipamentos de uso geral não especificados anteriormente, peças e acessórios'+#13#10+
            '2831300 - Fabricação de tratores agrícolas, peças e acessórios'+#13#10+
            '2832100 - Fabricação de equipamentos para irrigação agrícola, peças e acessórios'+#13#10+
            '2833000 - Fabricação de máquinas e equipamentos para a agricultura e pecuária, peças e acessórios, exceto para irrigação'+#13#10+
            '2840200 - Fabricação de máquinas-ferramenta, peças e acessórios'+#13#10+
            '2851800 - Fabricação de máquinas e equipamentos para a prospecção e extração de petróleo, peças e acessórios'+#13#10+
            '2852600 - Fabricação de outras máquinas e equipamentos para uso na extração mineral, peças e acessórios, exceto na extração de petróleo'+#13#10+
            '2853400 - Fabricação de tratores, peças e acessórios, exceto agrícolas'+#13#10+
            '2854200 - Fabricação de máquinas e equipamentos para terraplenagem, pavimentação e construção, peças e acessórios, exceto tratores'+#13#10+
            '2861500 - Fabricação de máquinas para a indústria metalúrgica, peças e acessórios, exceto máquinas-ferramenta'+#13#10+
            '2862300 - Fabricação de máquinas e equipamentos para as indústrias de alimentos, bebidas e fumo, peças e acessórios'+#13#10+
            '2863100 - Fabricação de máquinas e equipamentos para a indústria têxtil, peças e acessórios'+#13#10+
            '2864000 - Fabricação de máquinas e equipamentos para as indústrias do vestuário, do couro e de calçados, peças e acessórios'+#13#10+
            '2865800 - Fabricação de máquinas e equipamentos para as indústrias de celulose, papel e papelão e artefatos, peças e acessórios'+#13#10+
            '2866600 - Fabricação de máquinas e equipamentos para a indústria do plástico, peças e acessórios'+#13#10+
            '2869100 - Fabricação de máquinas e equipamentos para uso industrial específico não especificados anteriormente, peças e acessórios'+#13#10+
            '2910701 - Fabricação de automóveis, camionetas e utilitários'+#13#10+
            '2910702 - Fabricação de chassis com motor para automóveis, camionetas e utilitários'+#13#10+
            '2910703 - Fabricação de motores para automóveis, camionetas e utilitários'+#13#10+
            '2920401 - Fabricação de caminhões e ônibus'+#13#10+
            '2920402 - Fabricação de motores para caminhões e ônibus'+#13#10+
            '2930101 - Fabricação de cabines, carrocerias e reboques para caminhões'+#13#10+
            '2930102 - Fabricação de carrocerias para ônibus'+#13#10+
            '2930103 - Fabricação de cabines, carrocerias e reboques para outros veículos automotores, exceto caminhões e ônibus'+#13#10+
            '2941700 - Fabricação de peças e acessórios para o sistema motor de veículos automotores'+#13#10+
            '2942500 - Fabricação de peças e acessórios para os sistemas de marcha e transmissão de veículos automotores'+#13#10+
            '2943300 - Fabricação de peças e acessórios para o sistema de freios de veículos automotores'+#13#10+
            '2944100 - Fabricação de peças e acessórios para o sistema de direção e suspensão de veículos automotores'+#13#10+
            '2945000 - Fabricação de material elétrico e eletrônico para veículos automotores, exceto baterias'+#13#10+
            '2949201 - Fabricação de bancos e estofados para veículos automotores'+#13#10+
            '2949299 - Fabricação de outras peças e acessórios para veículos automotores não especificadas anteriormente'+#13#10+
            '2950600 - Recondicionamento e recuperação de motores para veículos automotores'+#13#10+
            '3011301 - Construção de embarcações de grande porte'+#13#10+
            '3011302 - Construção de embarcações para uso comercial e para usos especiais, exceto de grande porte'+#13#10+
            '3012100 - Construção de embarcações para esporte e lazer'+#13#10+
            '3031800 - Fabricação de locomotivas, vagões e outros materiais rodantes'+#13#10+
            '3032600 - Fabricação de peças e acessórios para veículos ferroviários'+#13#10+
            '3041500 - Fabricação de aeronaves'+#13#10+
            '3042300 - Fabricação de turbinas, motores e outros componentes e peças para aeronaves'+#13#10+
            '3050400 - Fabricação de veículos militares de combate'+#13#10+
            '3091101 - Fabricação de motocicletas'+#13#10+
            '3091102 - Fabricação de peças e acessórios para motocicletas'+#13#10+
            '3092000 - Fabricação de bicicletas e triciclos não motorizados, peças e acessórios'+#13#10+
            '3099700 - Fabricação de equipamentos de transporte não especificados anteriormente'+#13#10+
            '3101200 - Fabricação de móveis com predominância de madeira'+#13#10+
            '3102100 - Fabricação de móveis com predominância de metal'+#13#10+
            '3103900 - Fabricação de móveis de outros materiais, exceto madeira e metal'+#13#10+
            '3104700 - Fabricação de colchões'+#13#10+
            '3211601 - Lapidação de gemas'+#13#10+
            '3211602 - Fabricação de artefatos de joalheria e ourivesaria'+#13#10+
            '3211603 - Cunhagem de moedas e medalhas'+#13#10+
            '3212400 - Fabricação de bijuterias e artefatos semelhantes'+#13#10+
            '3220500 - Fabricação de instrumentos musicais, peças e acessórios'+#13#10+
            '3230200 - Fabricação de artefatos para pesca e esporte'+#13#10+
            '3240001 - Fabricação de jogos eletrônicos'+#13#10+
            '3240002 - Fabricação de mesas de bilhar, de sinuca e acessórios não associada à locação'+#13#10+
            '3240003 - Fabricação de mesas de bilhar, de sinuca e acessórios associada à locação'+#13#10+
            '3240099 - Fabricação de outros brinquedos e jogos recreativos não especificados anteriormente'+#13#10+
            '3250701 - Fabricação de instrumentos não eletrônicos e utensílios para uso médico, cirúrgico, odontológico e de laboratório'+#13#10+
            '3250702 - Fabricação de mobiliário para uso médico, cirúrgico, odontológico e de laboratório'+#13#10+
            '3250703 - Fabricação de aparelhos e utensílios para correção de defeitos físicos e aparelhos ortopédicos em geral sob encomenda'+#13#10+
            '3250704 - Fabricação de aparelhos e utensílios para correção de defeitos físicos e aparelhos ortopédicos em geral, exceto sob encomenda'+#13#10+
            '3250705 - Fabricação de materiais para medicina e odontologia'+#13#10+
            '3250706 - Serviços de prótese dentária'+#13#10+
            '3250707 - Fabricação de artigos ópticos'+#13#10+
            '3250709 - Serviço de laboratório óptico'+#13#10+
            '3291400 - Fabricação de escovas, pincéis e vassouras'+#13#10+
            '3292201 - Fabricação de roupas de proteção e segurança e resistentes a fogo'+#13#10+
            '3292202 - Fabricação de equipamentos e acessórios para segurança pessoal e profissional'+#13#10+
            '3299001 - Fabricação de guarda-chuvas e similares'+#13#10+
            '3299002 - Fabricação de canetas, lápis e outros artigos para escritório'+#13#10+
            '3299003 - Fabricação de letras, letreiros e placas de qualquer material, exceto luminosos'+#13#10+
            '3299004 - Fabricação de painéis e letreiros luminosos'+#13#10+
            '3299005 - Fabricação de aviamentos para costura'+#13#10+
            '3299006 - Fabricação de velas, inclusive decorativas'+#13#10+
            '3299099 - Fabricação de produtos diversos não especificados anteriormente'+#13#10+
            '3311200 - Manutenção e reparação de tanques, reservatórios metálicos e caldeiras, exceto para veículos'+#13#10+
            '3312102 - Manutenção e reparação de aparelhos e instrumentos de medida, teste e controle'+#13#10+
            '3312103 - Manutenção e reparação de aparelhos eletromédicos e eletroterapêuticos e equipamentos de irradiação'+#13#10+
            '3312104 - Manutenção e reparação de equipamentos e instrumentos ópticos'+#13#10+
            '3313901 - Manutenção e reparação de geradores, transformadores e motores elétricos'+#13#10+
            '3313902 - Manutenção e reparação de baterias e acumuladores elétricos, exceto para veículos'+#13#10+
            '3313999 - Manutenção e reparação de máquinas, aparelhos e materiais elétricos não especificados anteriormente'+#13#10+
            '3314701 - Manutenção e reparação de máquinas motrizes não elétricas'+#13#10+
            '3314702 - Manutenção e reparação de equipamentos hidráulicos e pneumáticos, exceto válvulas'+#13#10+
            '3314703 - Manutenção e reparação de válvulas industriais'+#13#10+
            '3314704 - Manutenção e reparação de compressores'+#13#10+
            '3314705 - Manutenção e reparação de equipamentos de transmissão para fins industriais'+#13#10+
            '3314706 - Manutenção e reparação de máquinas, aparelhos e equipamentos para instalações térmicas'+#13#10+
            '3314707 - Manutenção e reparação de máquinas e aparelhos de refrigeração e ventilação para uso industrial e comercial'+#13#10+
            '3314708 - Manutenção e reparação de máquinas, equipamentos e aparelhos para transporte e elevação de cargas'+#13#10+
            '3314709 - Manutenção e reparação de máquinas de escrever, calcular e de outros equipamentos não eletrônicos para escritório'+#13#10+
            '3314710 - Manutenção e reparação de máquinas e equipamentos para uso geral não especificados anteriormente'+#13#10+
            '3314711 - Manutenção e reparação de máquinas e equipamentos para agricultura e pecuária'+#13#10+
            '3314712 - Manutenção e reparação de tratores agrícolas'+#13#10+
            '3314713 - Manutenção e reparação de máquinas-ferramenta'+#13#10+
            '3314714 - Manutenção e reparação de máquinas e equipamentos para a prospecção e extração de petróleo'+#13#10+
            '3314715 - Manutenção e reparação de máquinas e equipamentos para uso na extração mineral, exceto na extração de petróleo'+#13#10+
            '3314716 - Manutenção e reparação de tratores, exceto agrícolas'+#13#10+
            '3314717 - Manutenção e reparação de máquinas e equipamentos de terraplenagem, pavimentação e construção, exceto tratores'+#13#10+
            '3314718 - Manutenção e reparação de máquinas para a indústria metalúrgica, exceto máquinas-ferramenta'+#13#10+
            '3314719 - Manutenção e reparação de máquinas e equipamentos para as indústrias de alimentos, bebidas e fumo'+#13#10+
            '3314720 - Manutenção e reparação de máquinas e equipamentos para a indústria têxtil, do vestuário, do couro e calçados'+#13#10+
            '3314721 - Manutenção e reparação de máquinas e aparelhos para a indústria de celulose, papel e papelão e artefatos'+#13#10+
            '3314722 - Manutenção e reparação de máquinas e aparelhos para a indústria do plástico'+#13#10+
            '3314799 - Manutenção e reparação de outras máquinas e equipamentos para usos industriais não especificados anteriormente'+#13#10+
            '3315500 - Manutenção e reparação de veículos ferroviários'+#13#10+
            '3316301 - Manutenção e reparação de aeronaves, exceto a manutenção na pista'+#13#10+
            '3316302 - Manutenção de aeronaves na pista'+#13#10+
            '3317101 - Manutenção e reparação de embarcações e estruturas flutuantes'+#13#10+
            '3317102 - Manutenção e reparação de embarcações para esporte e lazer'+#13#10+
            '3319800 - Manutenção e reparação de equipamentos e produtos não especificados anteriormente'+#13#10+
            '3321000 - Instalação de máquinas e equipamentos industriais'+#13#10+
            '3329501 - Serviços de montagem de móveis de qualquer material'+#13#10+
            '3329599 - Instalação de outros equipamentos não especificados anteriormente'+#13#10+
            '3511501 - Geração de energia elétrica'+#13#10+
            '3511502 - Atividades de coordenação e controle da operação da geração e transmissão de energia elétrica'+#13#10+
            '3512300 - Transmissão de energia elétrica'+#13#10+
            '3513100 - Comércio atacadista de energia elétrica'+#13#10+
            '3514000 - Distribuição de energia elétrica'+#13#10+
            '3520401 - Produção de gás; processamento de gás natural'+#13#10+
            '3520402 - Distribuição de combustíveis gasosos por redes urbanas'+#13#10+
            '3530100 - Produção e distribuição de vapor, água quente e ar condicionado'+#13#10+
            '3600601 - Captação, tratamento e distribuição de água'+#13#10+
            '3600602 - Distribuição de água por caminhões'+#13#10+
            '3701100 - Gestão de redes de esgoto'+#13#10+
            '3702900 - Atividades relacionadas a esgoto, exceto a gestão de redes'+#13#10+
            '3811400 - Coleta de resíduos não perigosos'+#13#10+
            '3812200 - Coleta de resíduos perigosos'+#13#10+
            '3821100 - Tratamento e disposição de resíduos não perigosos'+#13#10+
            '3822000 - Tratamento e disposição de resíduos perigosos'+#13#10+
            '3831901 - Recuperação de sucatas de alumínio'+#13#10+
            '3831999 - Recuperação de materiais metálicos, exceto alumínio'+#13#10+
            '3832700 - Recuperação de materiais plásticos'+#13#10+
            '3839401 - Usinas de compostagem'+#13#10+
            '3839499 - Recuperação de materiais não especificados anteriormente'+#13#10+
            '3900500 - Descontaminação e outros serviços de gestão de resíduos'+#13#10+
            '4110700 - Incorporação de empreendimentos imobiliários'+#13#10+
            '4120400 - Construção de edifícios'+#13#10+
            '4211101 - Construção de rodovias e ferrovias'+#13#10+
            '4211102 - Pintura para sinalização em pistas rodoviárias e aeroportos'+#13#10+
            '4212000 - Construção de obras de arte especiais'+#13#10+
            '4213800 - Obras de urbanização - ruas, praças e calçadas'+#13#10+
            '4221901 - Construção de barragens e represas para geração de energia elétrica'+#13#10+
            '4221902 - Construção de estações e redes de distribuição de energia elétrica'+#13#10+
            '4221903 - Manutenção de redes de distribuição de energia elétrica'+#13#10+
            '4221904 - Construção de estações e redes de telecomunicações'+#13#10+
            '4221905 - Manutenção de estações e redes de telecomunicações'+#13#10+
            '4222701 - Construção de redes de abastecimento de água, coleta de esgoto e construções correlatas, exceto obras de irrigação'+#13#10+
            '4222702 - Obras de irrigação'+#13#10+
            '4223500 - Construção de redes de transportes por dutos, exceto para água e esgoto'+#13#10+
            '4291000 - Obras portuárias, marítimas e fluviais'+#13#10+
            '4292801 - Montagem de estruturas metálicas'+#13#10+
            '4292802 - Obras de montagem industrial'+#13#10+
            '4299501 - Construção de instalações esportivas e recreativas'+#13#10+
            '4299599 - Outras obras de engenharia civil não especificadas anteriormente'+#13#10+
            '4311801 - Demolição de edifícios e outras estruturas'+#13#10+
            '4311802 - Preparação de canteiro e limpeza de terreno'+#13#10+
            '4312600 - Perfurações e sondagens'+#13#10+
            '4313400 - Obras de terraplenagem'+#13#10+
            '4319300 - Serviços de preparação do terreno não especificados anteriormente'+#13#10+
            '4321500 - Instalação e manutenção elétrica'+#13#10+
            '4322301 - Instalações hidráulicas, sanitárias e de gás'+#13#10+
            '4322302 - Instalação e manutenção de sistemas centrais de ar condicionado, de ventilação e refrigeração'+#13#10+
            '4322303 - Instalações de sistema de prevenção contra incêndio'+#13#10+
            '4329101 - Instalação de painéis publicitários'+#13#10+
            '4329102 - Instalação de equipamentos para orientação à navegação marítima, fluvial e lacustre'+#13#10+
            '4329103 - Instalação, manutenção e reparação de elevadores, escadas e esteiras rolantes'+#13#10+
            '4329104 - Montagem e instalação de sistemas e equipamentos de iluminação e sinalização em vias públicas, portos e aeroportos'+#13#10+
            '4329105 - Tratamentos térmicos, acústicos ou de vibração'+#13#10+
            '4329199 - Outras obras de instalações em construções não especificadas anteriormente'+#13#10+
            '4330401 - Impermeabilização em obras de engenharia civil'+#13#10+
            '4330402 - Instalação de portas, janelas, tetos, divisórias e armários embutidos de qualquer material'+#13#10+
            '4330403 - Obras de acabamento em gesso e estuque'+#13#10+
            '4330404 - Serviços de pintura de edifícios em geral'+#13#10+
            '4330405 - Aplicação de revestimentos e de resinas em interiores e exteriores'+#13#10+
            '4330499 - Outras obras de acabamento da construção'+#13#10+
            '4391600 - Obras de fundações'+#13#10+
            '4399101 - Administração de obras'+#13#10+
            '4399102 - Montagem e desmontagem de andaimes e outras estruturas temporárias'+#13#10+
            '4399103 - Obras de alvenaria'+#13#10+
            '4399104 - Serviços de operação e fornecimento de equipamentos para transporte e elevação de cargas e pessoas para uso em obras'+#13#10+
            '4399105 - Perfuração e construção de poços de água'+#13#10+
            '4399199 - Serviços especializados para construção não especificados anteriormente'+#13#10+
            '4511101 - Comércio a varejo de automóveis, camionetas e utilitários novos'+#13#10+
            '4511102 - Comércio a varejo de automóveis, camionetas e utilitários usados'+#13#10+
            '4511103 - Comércio por atacado de automóveis, camionetas e utilitários novos e usados'+#13#10+
            '4511104 - Comércio por atacado de caminhões novos e usados'+#13#10+
            '4511105 - Comércio por atacado de reboques e semireboques novos e usados'+#13#10+
            '4511106 - Comércio por atacado de ônibus e micro-ônibus novos e usados'+#13#10+
            '4512901 - Representantes comerciais e agentes do comércio de veículos automotores'+#13#10+
            '4512902 - Comércio sob consignação de veículos automotores'+#13#10+
            '4520001 - Serviços de manutenção e reparação mecânica de veículos automotores'+#13#10+
            '4520002 - Serviços de lanternagem ou funilaria e pintura de veículos automotores'+#13#10+
            '4520003 - Serviços de manutenção e reparação elétrica de veículos automotores'+#13#10+
            '4520004 - Serviços de alinhamento e balanceamento de veículos automotores'+#13#10+
            '4520005 - Serviços de lavagem, lubrificação e polimento de veículos automotores'+#13#10+
            '4520006 - Serviços de borracharia para veículos automotores'+#13#10+
            '4520007 - Serviços de instalação, manutenção e reparação de acessórios para veículos automotores'+#13#10+
            '4520008 - Serviços de capotaria'+#13#10+
            '4530701 - Comércio por atacado de peças e acessórios novos para veículos automotores'+#13#10+
            '4530702 - Comércio por atacado de pneumáticos e câmaras-de-ar'+#13#10+
            '4530703 - Comércio a varejo de peças e acessórios novos para veículos automotores'+#13#10+
            '4530704 - Comércio a varejo de peças e acessórios usados para veículos automotores'+#13#10+
            '4530705 - Comércio a varejo de pneumáticos e câmaras-de-ar'+#13#10+
            '4530706 - Representantes comerciais e agentes do comércio de peças e acessórios novos e usados para veículos automotores'+#13#10+
            '4541201 - Comércio por atacado de motocicletas e motonetas'+#13#10+
            '4541202 - Comércio por atacado de peças e acessórios para motocicletas e motonetas'+#13#10+
            '4541203 - Comércio a varejo de motocicletas e motonetas novas'+#13#10+
            '4541204 - Comércio a varejo de motocicletas e motonetas usadas'+#13#10+
            '4541206 - Comércio a varejo de peças e acessórios novos para motocicletas e motonetas'+#13#10+
            '4541207 - Comércio a varejo de peças e acessórios usados para motocicletas e motonetas'+#13#10+
            '4542101 - Representantes comerciais e agentes do comércio de motocicletas e motonetas, peças e acessórios'+#13#10+
            '4542102 - Comércio sob consignação de motocicletas e motonetas'+#13#10+
            '4543900 - Manutenção e reparação de motocicletas e motonetas'+#13#10+
            '4611700 - Representantes comerciais e agentes do comércio de matérias-primas agrícolas e animais vivos'+#13#10+
            '4612500 - Representantes comerciais e agentes do comércio de combustíveis, minerais, produtos siderúrgicos e químicos'+#13#10+
            '4613300 - Representantes comerciais e agentes do comércio de madeira, material de construção e ferragens'+#13#10+
            '4614100 - Representantes comerciais e agentes do comércio de máquinas, equipamentos, embarcações e aeronaves'+#13#10+
            '4615000 - Representantes comerciais e agentes do comércio de eletrodomésticos, móveis e artigos de uso doméstico'+#13#10+
            '4616800 - Representantes comerciais e agentes do comércio de têxteis, vestuário, calçados e artigos de viagem'+#13#10+
            '4617600 - Representantes comerciais e agentes do comércio de produtos alimentícios, bebidas e fumo'+#13#10+
            '4618401 - Representantes comerciais e agentes do comércio de medicamentos, cosméticos e produtos de perfumaria'+#13#10+
            '4618402 - Representantes comerciais e agentes do comércio de instrumentos e materiais odonto-médico-hospitalares'+#13#10+
            '4618403 - Representantes comerciais e agentes do comércio de jornais, revistas e outras publicações'+#13#10+
            '4618499 - Outros representantes comerciais e agentes do comércio especializado em produtos não especificados anteriormente'+#13#10+
            '4619200 - Representantes comerciais e agentes do comércio de mercadorias em geral não especializado'+#13#10+
            '4621400 - Comércio atacadista de café em grão'+#13#10+
            '4622200 - Comércio atacadista de soja'+#13#10+
            '4623101 - Comércio atacadista de animais vivos'+#13#10+
            '4623102 - Comércio atacadista de couros, lãs, peles e outros subprodutos não comestíveis de origem animal'+#13#10+
            '4623103 - Comércio atacadista de algodão'+#13#10+
            '4623104 - Comércio atacadista de fumo em folha não beneficiado'+#13#10+
            '4623105 - Comércio atacadista de cacau'+#13#10+
            '4623106 - Comércio atacadista de sementes, flores, plantas e gramas'+#13#10+
            '4623107 - Comércio atacadista de sisal'+#13#10+
            '4623108 - Comércio atacadista de matérias-primas agrícolas com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4623109 - Comércio atacadista de alimentos para animais'+#13#10+
            '4623199 - Comércio atacadista de matérias-primas agrícolas não especificadas anteriormente'+#13#10+
            '4631100 - Comércio atacadista de leite e laticínios'+#13#10+
            '4632001 - Comércio atacadista de cereais e leguminosas beneficiados'+#13#10+
            '4632002 - Comércio atacadista de farinhas, amidos e féculas'+#13#10+
            '4632003 - Comércio atacadista de cereais e leguminosas beneficiados, farinhas, amidos e féculas, com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4633801 - Comércio atacadista de frutas, verduras, raízes, tubérculos, hortaliças e legumes frescos'+#13#10+
            '4633802 - Comércio atacadista de aves vivas e ovos'+#13#10+
            '4633803 - Comércio atacadista de coelhos e outros pequenos animais vivos para alimentação'+#13#10+
            '4634601 - Comércio atacadista de carnes bovinas e suínas e derivados'+#13#10+
            '4634602 - Comércio atacadista de aves abatidas e derivados'+#13#10+
            '4634603 - Comércio atacadista de pescados e frutos do mar'+#13#10+
            '4634699 - Comércio atacadista de carnes e derivados de outros animais'+#13#10+
            '4635401 - Comércio atacadista de água mineral'+#13#10+
            '4635402 - Comércio atacadista de cerveja, chope e refrigerante'+#13#10+
            '4635403 - Comércio atacadista de bebidas com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4635499 - Comércio atacadista de bebidas não especificadas anteriormente'+#13#10+
            '4636201 - Comércio atacadista de fumo beneficiado'+#13#10+
            '4636202 - Comércio atacadista de cigarros, cigarrilhas e charutos'+#13#10+
            '4637101 - Comércio atacadista de café torrado, moído e solúvel'+#13#10+
            '4637102 - Comércio atacadista de açúcar'+#13#10+
            '4637103 - Comércio atacadista de óleos e gorduras'+#13#10+
            '4637104 - Comércio atacadista de pães, bolos, biscoitos e similares'+#13#10+
            '4637105 - Comércio atacadista de massas alimentícias'+#13#10+
            '4637106 - Comércio atacadista de sorvetes'+#13#10+
            '4637107 - Comércio atacadista de chocolates, confeitos, balas, bombons e semelhantes'+#13#10+
            '4637199 - Comércio atacadista especializado em outros produtos alimentícios não especificados anteriormente'+#13#10+
            '4639701 - Comércio atacadista de produtos alimentícios em geral'+#13#10+
            '4639702 - Comércio atacadista de produtos alimentícios em geral, com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4641901 - Comércio atacadista de tecidos'+#13#10+
            '4641902 - Comércio atacadista de artigos de cama, mesa e banho'+#13#10+
            '4641903 - Comércio atacadista de artigos de armarinho'+#13#10+
            '4642701 - Comércio atacadista de artigos do vestuário e acessórios, exceto profissionais e de segurança'+#13#10+
            '4642702 - Comércio atacadista de roupas e acessórios para uso profissional e de segurança do trabalho'+#13#10+
            '4643501 - Comércio atacadista de calçados'+#13#10+
            '4643502 - Comércio atacadista de bolsas, malas e artigos de viagem'+#13#10+
            '4644301 - Comércio atacadista de medicamentos e drogas de uso humano'+#13#10+
            '4644302 - Comércio atacadista de medicamentos e drogas de uso veterinário'+#13#10+
            '4645101 - Comércio atacadista de instrumentos e materiais para uso médico, cirúrgico, hospitalar e de laboratórios'+#13#10+
            '4645102 - Comércio atacadista de próteses e artigos de ortopedia'+#13#10+
            '4645103 - Comércio atacadista de produtos odontológicos'+#13#10+
            '4646001 - Comércio atacadista de cosméticos e produtos de perfumaria'+#13#10+
            '4646002 - Comércio atacadista de produtos de higiene pessoal'+#13#10+
            '4647801 - Comércio atacadista de artigos de escritório e de papelaria'+#13#10+
            '4647802 - Comércio atacadista de livros, jornais e outras publicações'+#13#10+
            '4649401 - Comércio atacadista de equipamentos elétricos de uso pessoal e doméstico'+#13#10+
            '4649402 - Comércio atacadista de aparelhos eletrônicos de uso pessoal e doméstico'+#13#10+
            '4649403 - Comércio atacadista de bicicletas, triciclos e outros veículos recreativos'+#13#10+
            '4649404 - Comércio atacadista de móveis e artigos de colchoaria'+#13#10+
            '4649405 - Comércio atacadista de artigos de tapeçaria; persianas e cortinas'+#13#10+
            '4649406 - Comércio atacadista de lustres, luminárias e abajures'+#13#10+
            '4649407 - Comércio atacadista de filmes, CDs, DVDs, fitas e discos'+#13#10+
            '4649408 - Comércio atacadista de produtos de higiene, limpeza e conservação domiciliar'+#13#10+
            '4649409 - Comércio atacadista de produtos de higiene, limpeza e conservação domiciliar, com atividade de fracionamento e acondicionamento associada'+#13#10+
            '4649410 - Comércio atacadista de jóias, relógios e bijuterias, inclusive pedras preciosas e semipreciosas lapidadas'+#13#10+
            '4649499 - Comércio atacadista de outros equipamentos e artigos de uso pessoal e doméstico não especificados anteriormente'+#13#10+
            '4651601 - Comércio atacadista de equipamentos de informática'+#13#10+
            '4651602 - Comércio atacadista de suprimentos para informática'+#13#10+
            '4652400 - Comércio atacadista de componentes eletrônicos e equipamentos de telefonia e comunicação'+#13#10+
            '4661300 - Comércio atacadista de máquinas, aparelhos e equipamentos para uso agropecuário; partes e peças'+#13#10+
            '4662100 - Comércio atacadista de máquinas, equipamentos para terraplenagem, mineração e construção; partes e peças'+#13#10+
            '4663000 - Comércio atacadista de máquinas e equipamentos para uso industrial; partes e peças'+#13#10+
            '4664800 - Comércio atacadista de máquinas, aparelhos e equipamentos para uso odonto-médico-hospitalar; partes e peças'+#13#10+
            '4665600 - Comércio atacadista de máquinas e equipamentos para uso comercial; partes e peças'+#13#10+
            '4669901 - Comércio atacadista de bombas e compressores; partes e peças'+#13#10+
            '4669999 - Comércio atacadista de outras máquinas e equipamentos não especificados anteriormente; partes e peças'+#13#10+
            '4671100 - Comércio atacadista de madeira e produtos derivados'+#13#10+
            '4672900 - Comércio atacadista de ferragens e ferramentas'+#13#10+
            '4673700 - Comércio atacadista de material elétrico'+#13#10+
            '4674500 - Comércio atacadista de cimento'+#13#10+
            '4679601 - Comércio atacadista de tintas, vernizes e similares'+#13#10+
            '4679602 - Comércio atacadista de mármores e granitos'+#13#10+
            '4679603 - Comércio atacadista de vidros, espelhos e vitrais'+#13#10+
            '4679604 - Comércio atacadista especializado de materiais de construção não especificados anteriormente'+#13#10+
            '4679699 - Comércio atacadista de materiais de construção em geral'+#13#10+
            '4681801 - Comércio atacadista de álcool carburante, biodiesel, gasolina e demais derivados de petróleo, exceto lubrificantes, não realizado por transportador retalhista (TRR)'+#13#10+
            '4681802 - Comércio atacadista de combustíveis realizado por transportador retalhista (TRR)'+#13#10+
            '4681803 - Comércio atacadista de combustíveis de origem vegetal, exceto álcool carburante'+#13#10+
            '4681804 - Comércio atacadista de combustíveis de origem mineral em bruto'+#13#10+
            '4681805 - Comércio atacadista de lubrificantes'+#13#10+
            '4682600 - Comércio atacadista de gás liquefeito de petróleo (GLP)'+#13#10+
            '4683400 - Comércio atacadista de defensivos agrícolas, adubos, fertilizantes e corretivos do solo'+#13#10+
            '4684201 - Comércio atacadista de resinas e elastômeros'+#13#10+
            '4684202 - Comércio atacadista de solventes'+#13#10+
            '4684299 - Comércio atacadista de outros produtos químicos e petroquímicos não especificados anteriormente'+#13#10+
            '4685100 - Comércio atacadista de produtos siderúrgicos e metalúrgicos, exceto para construção'+#13#10+
            '4686901 - Comércio atacadista de papel e papelão em bruto'+#13#10+
            '4686902 - Comércio atacadista de embalagens'+#13#10+
            '4687701 - Comércio atacadista de resíduos de papel e papelão'+#13#10+
            '4687702 - Comércio atacadista de resíduos e sucatas não metálicos, exceto de papel e papelão'+#13#10+
            '4687703 - Comércio atacadista de resíduos e sucatas metálicos'+#13#10+
            '4689301 - Comércio atacadista de produtos da extração mineral, exceto combustíveis'+#13#10+
            '4689302 - Comércio atacadista de fios e fibras beneficiados'+#13#10+
            '4689399 - Comércio atacadista especializado em outros produtos intermediários não especificados anteriormente'+#13#10+
            '4691500 - Comércio atacadista de mercadorias em geral, com predominância de produtos alimentícios'+#13#10+
            '4692300 - Comércio atacadista de mercadorias em geral, com predominância de insumos agropecuários'+#13#10+
            '4693100 - Comércio atacadista de mercadorias em geral, sem predominância de alimentos ou de insumos agropecuários'+#13#10+
            '4711301 - Comércio varejista de mercadorias em geral, com predominância de produtos alimentícios - hipermercados'+#13#10+
            '4711302 - Comércio varejista de mercadorias em geral, com predominância de produtos alimentícios - supermercados'+#13#10+
            '4712100 - Comércio varejista de mercadorias em geral, com predominância de produtos alimentícios - minimercados, mercearias e armazéns'+#13#10+
            '4713002 - Lojas de variedades, exceto lojas de departamentos ou magazines'+#13#10+
            '4713004 - Lojas de departamentos ou magazines, exceto lojas francas (Duty free)'+#13#10+
            '4713005 - Lojas francas (Duty Free) de aeroportos, portos e em fronteiras terrestres'+#13#10+
            '4721102 - Padaria e confeitaria com predominância de revenda'+#13#10+
            '4721103 - Comércio varejista de laticínios e frios'+#13#10+
            '4721104 - Comércio varejista de doces, balas, bombons e semelhantes'+#13#10+
            '4722901 - Comércio varejista de carnes - açougues'+#13#10+
            '4722902 - Peixaria'+#13#10+
            '4723700 - Comércio varejista de bebidas'+#13#10+
            '4724500 - Comércio varejista de hortifrutigranjeiros'+#13#10+
            '4729601 - Tabacaria'+#13#10+
            '4729602 - Comércio varejista de mercadorias em lojas de conveniência'+#13#10+
            '4729699 - Comércio varejista de produtos alimentícios em geral ou especializado em produtos alimentícios não especificados anteriormente'+#13#10+
            '4731800 - Comércio varejista de combustíveis para veículos automotores'+#13#10+
            '4732600 - Comércio varejista de lubrificantes'+#13#10+
            '4741500 - Comércio varejista de tintas e materiais para pintura'+#13#10+
            '4742300 - Comércio varejista de material elétrico'+#13#10+
            '4743100 - Comércio varejista de vidros'+#13#10+
            '4744001 - Comércio varejista de ferragens e ferramentas'+#13#10+
            '4744002 - Comércio varejista de madeira e artefatos'+#13#10+
            '4744003 - Comércio varejista de materiais hidráulicos'+#13#10+
            '4744004 - Comércio varejista de cal, areia, pedra britada, tijolos e telhas'+#13#10+
            '4744005 - Comércio varejista de materiais de construção não especificados anteriormente'+#13#10+
            '4744006 - Comércio varejista de pedras para revestimento'+#13#10+
            '4744099 - Comércio varejista de materiais de construção em geral'+#13#10+
            '4751201 - Comércio varejista especializado de equipamentos e suprimentos de informática'+#13#10+
            '4751202 - Recarga de cartuchos para equipamentos de informática'+#13#10+
            '4752100 - Comércio varejista especializado de equipamentos de telefonia e comunicação'+#13#10+
            '4753900 - Comércio varejista especializado de eletrodomésticos e equipamentos de áudio e vídeo'+#13#10+
            '4754701 - Comércio varejista de móveis'+#13#10+
            '4754702 - Comércio varejista de artigos de colchoaria'+#13#10+
            '4754703 - Comércio varejista de artigos de iluminação'+#13#10+
            '4755501 - Comércio varejista de tecidos'+#13#10+
            '4755502 - Comercio varejista de artigos de armarinho'+#13#10+
            '4755503 - Comercio varejista de artigos de cama, mesa e banho'+#13#10+
            '4756300 - Comércio varejista especializado de instrumentos musicais e acessórios'+#13#10+
            '4757100 - Comércio varejista especializado de peças e acessórios para aparelhos eletroeletrônicos para uso doméstico, exceto informática e comunicação'+#13#10+
            '4759801 - Comércio varejista de artigos de tapeçaria, cortinas e persianas'+#13#10+
            '4759899 - Comércio varejista de outros artigos de uso doméstico não especificados anteriormente'+#13#10+
            '4761001 - Comércio varejista de livros'+#13#10+
            '4761002 - Comércio varejista de jornais e revistas'+#13#10+
            '4761003 - Comércio varejista de artigos de papelaria'+#13#10+
            '4762800 - Comércio varejista de discos, CDs, DVDs e fitas'+#13#10+
            '4763601 - Comércio varejista de brinquedos e artigos recreativos'+#13#10+
            '4763602 - Comércio varejista de artigos esportivos'+#13#10+
            '4763603 - Comércio varejista de bicicletas e triciclos; peças e acessórios'+#13#10+
            '4763604 - Comércio varejista de artigos de caça, pesca e camping'+#13#10+
            '4763605 - Comércio varejista de embarcações e outros veículos recreativos; peças e acessórios'+#13#10+
            '4771701 - Comércio varejista de produtos farmacêuticos, sem manipulação de fórmulas'+#13#10+
            '4771702 - Comércio varejista de produtos farmacêuticos, com manipulação de fórmulas'+#13#10+
            '4771703 - Comércio varejista de produtos farmacêuticos homeopáticos'+#13#10+
            '4771704 - Comércio varejista de medicamentos veterinários'+#13#10+
            '4772500 - Comércio varejista de cosméticos, produtos de perfumaria e de higiene pessoal'+#13#10+
            '4773300 - Comércio varejista de artigos médicos e ortopédicos'+#13#10+
            '4774100 - Comércio varejista de artigos de óptica'+#13#10+
            '4781400 - Comércio varejista de artigos do vestuário e acessórios'+#13#10+
            '4782201 - Comércio varejista de calçados'+#13#10+
            '4782202 - Comércio varejista de artigos de viagem'+#13#10+
            '4783101 - Comércio varejista de artigos de joalheria'+#13#10+
            '4783102 - Comércio varejista de artigos de relojoaria'+#13#10+
            '4784900 - Comércio varejista de gás liqüefeito de petróleo (GLP)'+#13#10+
            '4785701 - Comércio varejista de antiguidades'+#13#10+
            '4785799 - Comércio varejista de outros artigos usados'+#13#10+
            '4789001 - Comércio varejista de suvenires, bijuterias e artesanatos'+#13#10+
            '4789002 - Comércio varejista de plantas e flores naturais'+#13#10+
            '4789003 - Comércio varejista de objetos de arte'+#13#10+
            '4789004 - Comércio varejista de animais vivos e de artigos e alimentos para animais de estimação'+#13#10+
            '4789005 - Comércio varejista de produtos saneantes domissanitários'+#13#10+
            '4789006 - Comércio varejista de fogos de artifício e artigos pirotécnicos'+#13#10+
            '4789007 - Comércio varejista de equipamentos para escritório'+#13#10+
            '4789008 - Comércio varejista de artigos fotográficos e para filmagem'+#13#10+
            '4789009 - Comércio varejista de armas e munições'+#13#10+
            '4789099 - Comércio varejista de outros produtos não especificados anteriormente'+#13#10+
            '4911600 - Transporte ferroviário de carga'+#13#10+
            '4912401 - Transporte ferroviário de passageiros intermunicipal e interestadual'+#13#10+
            '4912402 - Transporte ferroviário de passageiros municipal e em região metropolitana'+#13#10+
            '4912403 - Transporte metroviário'+#13#10+
            '4921301 - Transporte rodoviário coletivo de passageiros, com itinerário fixo, municipal'+#13#10+
            '4921302 - Transporte rodoviário coletivo de passageiros, com itinerário fixo, intermunicipal em região metropolitana'+#13#10+
            '4922101 - Transporte rodoviário coletivo de passageiros, com itinerário fixo, intermunicipal, exceto em região metropolitana'+#13#10+
            '4922102 - Transporte rodoviário coletivo de passageiros, com itinerário fixo, interestadual'+#13#10+
            '4922103 - Transporte rodoviário coletivo de passageiros, com itinerário fixo, internacional'+#13#10+
            '4923001 - Serviço de táxi'+#13#10+
            '4923002 - Serviço de transporte de passageiros - locação de automóveis com motorista'+#13#10+
            '4924800 - Transporte escolar'+#13#10+
            '4929901 - Transporte rodoviário coletivo de passageiros, sob regime de fretamento, municipal'+#13#10+
            '4929902 - Transporte rodoviário coletivo de passageiros, sob regime de fretamento, intermunicipal, interestadual e internacional'+#13#10+
            '4929903 - Organização de excursões em veículos rodoviários próprios, municipal'+#13#10+
            '4929904 - Organização de excursões em veículos rodoviários próprios, intermunicipal, interestadual e internacional'+#13#10+
            '4929999 - Outros transportes rodoviários de passageiros não especificados anteriormente'+#13#10+
            '4930201 - Transporte rodoviário de carga, exceto produtos perigosos e mudanças, municipal'+#13#10+
            '4930202 - Transporte rodoviário de carga, exceto produtos perigosos e mudanças, intermunicipal, interestadual e internacional'+#13#10+
            '4930203 - Transporte rodoviário de produtos perigosos'+#13#10+
            '4930204 - Transporte rodoviário de mudanças'+#13#10+
            '4940000 - Transporte dutoviário'+#13#10+
            '4950700 - Trens turísticos, teleféricos e similares'+#13#10+
            '5011401 - Transporte marítimo de cabotagem - Carga'+#13#10+
            '5011402 - Transporte marítimo de cabotagem - Passageiros'+#13#10+
            '5012201 - Transporte marítimo de longo curso - Carga'+#13#10+
            '5012202 - Transporte marítimo de longo curso - Passageiros'+#13#10+
            '5021101 - Transporte por navegação interior de carga, municipal, exceto travessia'+#13#10+
            '5021102 - Transporte por navegação interior de carga, intermunicipal, interestadual e internacional, exceto travessia'+#13#10+
            '5022001 - Transporte por navegação interior de passageiros em linhas regulares, municipal, exceto travessia'+#13#10+
            '5022002 - Transporte por navegação interior de passageiros em linhas regulares, intermunicipal, interestadual e internacional, exceto travessia'+#13#10+
            '5030101 - Navegação de apoio marítimo'+#13#10+
            '5030102 - Navegação de apoio portuário'+#13#10+
            '5030103 - Serviço de rebocadores e empurradores'+#13#10+
            '5091201 - Transporte por navegação de travessia, municipal'+#13#10+
            '5091202 - Transporte por navegação de travessia, intermunicipal, interestadual e internacional'+#13#10+
            '5099801 - Transporte aquaviário para passeios turísticos'+#13#10+
            '5099899 - Outros transportes aquaviários não especificados anteriormente'+#13#10+
            '5111100 - Transporte aéreo de passageiros regular'+#13#10+
            '5112901 - Serviço de táxi aéreo e locação de aeronaves com tripulação'+#13#10+
            '5112999 - Outros serviços de transporte aéreo de passageiros não regular'+#13#10+
            '5120000 - Transporte aéreo de carga'+#13#10+
            '5130700 - Transporte espacial'+#13#10+
            '5211701 - Armazéns gerais - emissão de warrant'+#13#10+
            '5211702 - Guarda-móveis'+#13#10+
            '5211799 - Depósitos de mercadorias para terceiros, exceto armazéns gerais e guarda-móveis'+#13#10+
            '5212500 - Carga e descarga'+#13#10+
            '5221400 - Concessionárias de rodovias, pontes, túneis e serviços relacionados'+#13#10+
            '5222200 - Terminais rodoviários e ferroviários'+#13#10+
            '5223100 - Estacionamento de veículos'+#13#10+
            '5229001 - Serviços de apoio ao transporte por táxi, inclusive centrais de chamada'+#13#10+
            '5229002 - Serviços de reboque de veículos'+#13#10+
            '5229099 - Outras atividades auxiliares dos transportes terrestres não especificadas anteriormente'+#13#10+
            '5231101 - Administração da infraestrutura portuária'+#13#10+
            '5231102 - Atividades do Operador Portuário'+#13#10+
            '5231103 - Gestão de terminais aquaviários'+#13#10+
            '5232000 - Atividades de agenciamento marítimo'+#13#10+
            '5239701 - Serviços de praticagem'+#13#10+
            '5239799 - Atividades auxiliares dos transportes aquaviários não especificadas anteriormente'+#13#10+
            '5240101 - Operação dos aeroportos e campos de aterrissagem'+#13#10+
            '5240199 - Atividades auxiliares dos transportes aéreos, exceto operação dos aeroportos e campos de aterrissagem'+#13#10+
            '5250801 - Comissaria de despachos'+#13#10+
            '5250802 - Atividades de despachantes aduaneiros'+#13#10+
            '5250803 - Agenciamento de cargas, exceto para o transporte marítimo'+#13#10+
            '5250804 - Organização logística do transporte de carga'+#13#10+
            '5250805 - Operador de transporte multimodal - OTM'+#13#10+
            '5310501 - Atividades do Correio Nacional'+#13#10+
            '5310502 - Atividades de franqueadas e permissionárias do Correio Nacional'+#13#10+
            '5320201 - Serviços de malote não realizados pelo Correio Nacional'+#13#10+
            '5320202 - Serviços de entrega rápida'+#13#10+
            '5510801 - Hotéis'+#13#10+
            '5510802 - Apart-hotéis'+#13#10+
            '5510803 - Motéis'+#13#10+
            '5590601 - Albergues, exceto assistenciais'+#13#10+
            '5590602 - Campings'+#13#10+
            '5590603 - Pensões (alojamento)'+#13#10+
            '5590699 - Outros alojamentos não especificados anteriormente'+#13#10+
            '5611201 - Restaurantes e similares'+#13#10+
            '5611203 - Lanchonetes, casas de chá, de sucos e similares'+#13#10+
            '5611204 - Bares e outros estabelecimentos especializados em servir bebidas, sem entretenimento'+#13#10+
            '5611205 - Bares e outros estabelecimentos especializados em servir bebidas, com entretenimento'+#13#10+
            '5612100 - Serviços ambulantes de alimentação'+#13#10+
            '5620101 - Fornecimento de alimentos preparados preponderantemente para empresas'+#13#10+
            '5620102 - Serviços de alimentação para eventos e recepções - bufê'+#13#10+
            '5620103 - Cantinas - serviços de alimentação privativos'+#13#10+
            '5620104 - Fornecimento de alimentos preparados preponderantemente para consumo domiciliar'+#13#10+
            '5811500 - Edição de livros'+#13#10+
            '5812301 - Edição de jornais diários'+#13#10+
            '5812302 - Edição de jornais não diários'+#13#10+
            '5813100 - Edição de revistas'+#13#10+
            '5819100 - Edição de cadastros, listas e outros produtos gráficos'+#13#10+
            '5821200 - Edição integrada à impressão de livros'+#13#10+
            '5822101 - Edição integrada à impressão de jornais diários'+#13#10+
            '5822102 - Edição integrada à impressão de jornais não diários'+#13#10+
            '5823900 - Edição integrada à impressão de revistas'+#13#10+
            '5829800 - Edição integrada à impressão de cadastros, listas e outros produtos gráficos'+#13#10+
            '5911101 - Estúdios cinematográficos'+#13#10+
            '5911102 - Produção de filmes para publicidade'+#13#10+
            '5911199 - Atividades de produção cinematográfica, de vídeos e de programas de televisão não especificadas anteriormente'+#13#10+
            '5912001 - Serviços de dublagem'+#13#10+
            '5912002 - Serviços de mixagem sonora em produção audiovisual'+#13#10+
            '5912099 - Atividades de pós-produção cinematográfica, de vídeos e de programas de televisão não especificadas anteriormente'+#13#10+
            '5913800 - Distribuição cinematográfica, de vídeo e de programas de televisão'+#13#10+
            '5914600 - Atividades de exibição cinematográfica'+#13#10+
            '5920100 - Atividades de gravação de som e de edição de música'+#13#10+
            '6010100 - Atividades de rádio'+#13#10+
            '6021700 - Atividades de televisão aberta'+#13#10+
            '6022501 - Programadoras'+#13#10+
            '6022502 - Atividades relacionadas à televisão por assinatura, exceto programadoras'+#13#10+
            '6110801 - Serviços de telefonia fixa comutada - STFC'+#13#10+
            '6110802 - Serviços de redes de transporte de telecomunicações - SRTT'+#13#10+
            '6110803 - Serviços de comunicação multimídia - SCM'+#13#10+
            '6110899 - Serviços de telecomunicações por fio não especificados anteriormente'+#13#10+
            '6120501 - Telefonia móvel celular'+#13#10+
            '6120502 - Serviço móvel especializado - SME'+#13#10+
            '6120599 - Serviços de telecomunicações sem fio não especificados anteriormente'+#13#10+
            '6130200 - Telecomunicações por satélite'+#13#10+
            '6141800 - Operadoras de televisão por assinatura por cabo'+#13#10+
            '6142600 - Operadoras de televisão por assinatura por micro-ondas'+#13#10+
            '6143400 - Operadoras de televisão por assinatura por satélite'+#13#10+
            '6190601 - Provedores de acesso às redes de comunicações'+#13#10+
            '6190602 - Provedores de voz sobre protocolo Internet - VOIP'+#13#10+
            '6190699 - Outras atividades de telecomunicações não especificadas anteriormente'+#13#10+
            '6201501 - Desenvolvimento de programas de computador sob encomenda'+#13#10+
            '6201502 - Web desing'+#13#10+
            '6202300 - Desenvolvimento e licenciamento de programas de computador customizáveis'+#13#10+
            '6203100 - Desenvolvimento e licenciamento de programas de computador não customizáveis'+#13#10+
            '6204000 - Consultoria em tecnologia da informação'+#13#10+
            '6209100 - Suporte técnico, manutenção e outros serviços em tecnologia da informação'+#13#10+
            '6311900 - Tratamento de dados, provedores de serviços de aplicação e serviços de hospedagem na Internet'+#13#10+
            '6319400 - Portais, provedores de conteúdo e outros serviços de informação na Internet'+#13#10+
            '6391700 - Agências de notícias'+#13#10+
            '6399200 - Outras atividades de prestação de serviços de informação não especificadas anteriormente'+#13#10+
            '6410700 - Banco Central'+#13#10+
            '6421200 - Bancos comerciais'+#13#10+
            '6422100 - Bancos múltiplos, com carteira comercial'+#13#10+
            '6423900 - Caixas econômicas'+#13#10+
            '6424701 - Bancos cooperativos'+#13#10+
            '6424702 - Cooperativas centrais de crédito'+#13#10+
            '6424703 - Cooperativas de crédito mútuo'+#13#10+
            '6424704 - Cooperativas de crédito rural'+#13#10+
            '6431000 - Bancos múltiplos, sem carteira comercial'+#13#10+
            '6432800 - Bancos de investimento'+#13#10+
            '6433600 - Bancos de desenvolvimento'+#13#10+
            '6434400 - Agências de fomento'+#13#10+
            '6435201 - Sociedades de crédito imobiliário'+#13#10+
            '6435202 - Associações de poupança e empréstimo'+#13#10+
            '6435203 - Companhias hipotecárias'+#13#10+
            '6436100 - Sociedades de crédito, financiamento e investimento - financeiras'+#13#10+
            '6437900 - Sociedades de crédito ao microempreendedor'+#13#10+
            '6438701 - Bancos de câmbio'+#13#10+
            '6438799 - Outras instituições de intermediação não monetária não especificadas anteriormente'+#13#10+
            '6440900 - Arrendamento mercantil'+#13#10+
            '6450600 - Sociedades de capitalização'+#13#10+
            '6461100 - Holdings de instituições financeiras'+#13#10+
            '6462000 - Holdings de instituições não financeiras'+#13#10+
            '6463800 - Outras sociedades de participação, exceto holdings'+#13#10+
            '6470101 - Fundos de investimento, exceto previdenciários e imobiliários'+#13#10+
            '6470102 - Fundos de investimento previdenciários'+#13#10+
            '6470103 - Fundos de investimento imobiliários'+#13#10+
            '6491300 - Sociedades de fomento mercantil - factoring'+#13#10+
            '6492100 - Securitização de créditos'+#13#10+
            '6493000 - Administração de consórcios para aquisição de bens e direitos'+#13#10+
            '6499901 - Clubes de investimento'+#13#10+
            '6499902 - Sociedades de investimento'+#13#10+
            '6499903 - Fundo garantidor de crédito'+#13#10+
            '6499904 - Caixas de financiamento de corporações'+#13#10+
            '6499905 - Concessão de crédito pelas OSCIP'+#13#10+
            '6499999 - Outras atividades de serviços financeiros não especificadas anteriormente'+#13#10+
            '6511101 - Sociedade seguradora de seguros vida'+#13#10+
            '6511102 - Planos de auxílio-funeral'+#13#10+
            '6512000 - Sociedade seguradora de seguros não vida'+#13#10+
            '6520100 - Sociedade seguradora de seguros-saúde'+#13#10+
            '6530800 - Resseguros'+#13#10+
            '6541300 - Previdência complementar fechada'+#13#10+
            '6542100 - Previdência complementar aberta'+#13#10+
            '6550200 - Planos de saúde'+#13#10+
            '6611801 - Bolsa de valores'+#13#10+
            '6611802 - Bolsa de mercadorias'+#13#10+
            '6611803 - Bolsa de mercadorias e futuros'+#13#10+
            '6611804 - Administração de mercados de balcão organizados'+#13#10+
            '6612601 - Corretoras de títulos e valores mobiliários'+#13#10+
            '6612602 - Distribuidoras de títulos e valores mobiliários'+#13#10+
            '6612603 - Corretoras de câmbio'+#13#10+
            '6612604 - Corretoras de contratos de mercadorias'+#13#10+
            '6612605 - Agentes de investimentos em aplicações financeiras'+#13#10+
            '6613400 - Administração de cartões de crédito'+#13#10+
            '6619301 - Serviços de liquidação e custódia'+#13#10+
            '6619302 - Correspondentes de instituições financeiras'+#13#10+
            '6619303 - Representações de bancos estrangeiros'+#13#10+
            '6619304 - Caixas eletrônicos'+#13#10+
            '6619305 - Operadoras de cartões de débito'+#13#10+
            '6619399 - Outras atividades auxiliares dos serviços financeiros não especificadas anteriormente'+#13#10+
            '6621501 - Peritos e avaliadores de seguros'+#13#10+
            '6621502 - Auditoria e consultoria atuarial'+#13#10+
            '6622300 - Corretores e agentes de seguros, de planos de previdência complementar e de saúde'+#13#10+
            '6629100 - Atividades auxiliares dos seguros, da previdência complementar e dos planos de saúde não especificadas anteriormente'+#13#10+
            '6630400 - Atividades de administração de fundos por contrato ou comissão'+#13#10+
            '6810201 - Compra e venda de imóveis próprios'+#13#10+
            '6810202 - Aluguel de imóveis próprios'+#13#10+
            '6810203 - Loteamento de imóveis próprios'+#13#10+
            '6821801 - Corretagem na compra e venda e avaliação de imóveis'+#13#10+
            '6821802 - Corretagem no aluguel de imóveis'+#13#10+
            '6822600 - Gestão e administração da propriedade imobiliária'+#13#10+
            '6911701 - Serviços advocatícios'+#13#10+
            '6911702 - Atividades auxiliares da justiça'+#13#10+
            '6911703 - Agente de propriedade industrial'+#13#10+
            '6912500 - Cartórios'+#13#10+
            '6920601 - Atividades de contabilidade'+#13#10+
            '6920602 - Atividades de consultoria e auditoria contábil e tributária'+#13#10+
            '7020400 - Atividades de consultoria em gestão empresarial, exceto consultoria técnica específica'+#13#10+
            '7111100 - Serviços de arquitetura'+#13#10+
            '7112000 - Serviços de engenharia'+#13#10+
            '7119701 - Serviços de cartografia, topografia e geodésia'+#13#10+
            '7119702 - Atividades de estudos geológicos'+#13#10+
            '7119703 - Serviços de desenho técnico relacionados à arquitetura e engenharia'+#13#10+
            '7119704 - Serviços de perícia técnica relacionados à segurança do trabalho'+#13#10+
            '7119799 - Atividades técnicas relacionadas à engenharia e arquitetura não especificadas anteriormente'+#13#10+
            '7120100 - Testes e análises técnicas'+#13#10+
            '7210000 - Pesquisa e desenvolvimento experimental em ciências físicas e naturais'+#13#10+
            '7220700 - Pesquisa e desenvolvimento experimental em ciências sociais e humanas'+#13#10+
            '7311400 - Agências de publicidade'+#13#10+
            '7312200 - Agenciamento de espaços para publicidade, exceto em veículos de comunicação'+#13#10+
            '7319001 - Criação de estandes para feiras e exposições'+#13#10+
            '7319002 - Promoção de vendas'+#13#10+
            '7319003 - Marketing direto'+#13#10+
            '7319004 - Consultoria em publicidade'+#13#10+
            '7319099 - Outras atividades de publicidade não especificadas anteriormente'+#13#10+
            '7320300 - Pesquisas de mercado e de opinião pública'+#13#10+
            '7410202 - Design de interiores'+#13#10+
            '7410203 - Desing de produto'+#13#10+
            '7410299 - Atividades de desing não especificadas anteriormente'+#13#10+
            '7420001 - Atividades de produção de fotografias, exceto aérea e submarina'+#13#10+
            '7420002 - Atividades de produção de fotografias aéreas e submarinas'+#13#10+
            '7420003 - Laboratórios fotográficos'+#13#10+
            '7420004 - Filmagem de festas e eventos'+#13#10+
            '7420005 - Serviços de microfilmagem'+#13#10+
            '7490101 - Serviços de tradução, interpretação e similares'+#13#10+
            '7490102 - Escafandria e mergulho'+#13#10+
            '7490103 - Serviços de agronomia e de consultoria às atividades agrícolas e pecuárias'+#13#10+
            '7490104 - Atividades de intermediação e agenciamento de serviços e negócios em geral, exceto imobiliários'+#13#10+
            '7490105 - Agenciamento de profissionais para atividades esportivas, culturais e artísticas'+#13#10+
            '7490199 - Outras atividades profissionais, científicas e técnicas não especificadas anteriormente'+#13#10+
            '7500100 - Atividades veterinárias'+#13#10+
            '7711000 - Locação de automóveis sem condutor'+#13#10+
            '7719501 - Locação de embarcações sem tripulação, exceto para fins recreativos'+#13#10+
            '7719502 - Locação de aeronaves sem tripulação'+#13#10+
            '7719599 - Locação de outros meios de transporte não especificados anteriormente, sem condutor'+#13#10+
            '7721700 - Aluguel de equipamentos recreativos e esportivos'+#13#10+
            '7722500 - Aluguel de fitas de vídeo, DVDs e similares'+#13#10+
            '7723300 - Aluguel de objetos do vestuário, jóias e acessórios'+#13#10+
            '7729201 - Aluguel de aparelhos de jogos eletrônicos'+#13#10+
            '7729202 - Aluguel de móveis, utensílios e aparelhos de uso doméstico e pessoal; instrumentos musicais'+#13#10+
            '7729203 - Aluguel de material médico'+#13#10+
            '7729299 - Aluguel de outros objetos pessoais e domésticos não especificados anteriormente'+#13#10+
            '7731400 - Aluguel de máquinas e equipamentos agrícolas sem operador'+#13#10+
            '7732201 - Aluguel de máquinas e equipamentos para construção sem operador, exceto andaimes'+#13#10+
            '7732202 - Aluguel de andaimes'+#13#10+
            '7733100 - Aluguel de máquinas e equipamentos para escritório'+#13#10+
            '7739001 - Aluguel de máquinas e equipamentos para extração de minérios e petróleo, sem operador'+#13#10+
            '7739002 - Aluguel de equipamentos científicos, médicos e hospitalares, sem operador'+#13#10+
            '7739003 - Aluguel de palcos, coberturas e outras estruturas de uso temporário, exceto andaimes'+#13#10+
            '7739099 - Aluguel de outras máquinas e equipamentos comerciais e industriais não especificados anteriormente, sem operador'+#13#10+
            '7740300 - Gestão de ativos intangíveis não financeiros'+#13#10+
            '7810800 - Seleção e agenciamento de mão de obra'+#13#10+
            '7820500 - Locação de mão de obra temporária'+#13#10+
            '7830200 - Fornecimento e gestão de recursos humanos para terceiros'+#13#10+
            '7911200 - Agências de viagens'+#13#10+
            '7912100 - Operadores turísticos'+#13#10+
            '7990200 - Serviços de reservas e outros serviços de turismo não especificados anteriormente'+#13#10+
            '8011101 - Atividades de vigilância e segurança privada'+#13#10+
            '8011102 - Serviços de adestramento de cães de guarda'+#13#10+
            '8012900 - Atividades de transporte de valores'+#13#10+
            '8020001 - Atividades de monitoramento de sistemas de segurança eletrônico'+#13#10+
            '8020002 - Outras atividades de serviços de segurança'+#13#10+
            '8030700 - Atividades de investigação particular'+#13#10+
            '8111700 - Serviços combinados para apoio a edifícios, exceto condomínios prediais'+#13#10+
            '8112500 - Condomínios prediais'+#13#10+
            '8121400 - Limpeza em prédios e em domicílios'+#13#10+
            '8122200 - Imunização e controle de pragas urbanas'+#13#10+
            '8129000 - Atividades de limpeza não especificadas anteriormente'+#13#10+
            '8130300 - Atividades paisagísticas'+#13#10+
            '8211300 - Serviços combinados de escritório e apoio administrativo'+#13#10+
            '8219901 - Fotocópias'+#13#10+
            '8219999 - Preparação de documentos e serviços especializados de apoio administrativo não especificados anteriormente'+#13#10+
            '8220200 - Atividades de teleatendimento'+#13#10+
            '8230001 - Serviços de organização de feiras, congressos, exposições e festas'+#13#10+
            '8230002 - Casas de festas e eventos'+#13#10+
            '8291100 - Atividades de cobrança e informações cadastrais'+#13#10+
            '8292000 - Envasamento e empacotamento sob contrato'+#13#10+
            '8299701 - Medição de consumo de energia elétrica, gás e água'+#13#10+
            '8299702 - Emissão de vales-alimentação, vales-transporte e similares'+#13#10+
            '8299703 - Serviços de gravação de carimbos, exceto confecção'+#13#10+
            '8299704 - Leiloeiros independentes'+#13#10+
            '8299705 - Serviços de levantamento de fundos sob contrato'+#13#10+
            '8299706 - Casas lotéricas'+#13#10+
            '8299707 - Salas de acesso à Internet'+#13#10+
            '8299799 - Outras atividades de serviços prestados principalmente às empresas não especificadas anteriormente'+#13#10+
            '8411600 - Administração pública em geral'+#13#10+
            '8412400 - Regulação das atividades de saúde, educação, serviços culturais e outros serviços sociais'+#13#10+
            '8413200 - Regulação das atividades econômicas'+#13#10+
            '8421300 - Relações exteriores'+#13#10+
            '8422100 - Defesa'+#13#10+
            '8423000 - Justiça'+#13#10+
            '8424800 - Segurança e ordem pública'+#13#10+
            '8425600 - Defesa Civil'+#13#10+
            '8430200 - Seguridade social obrigatória'+#13#10+
            '8511200 - Educação infantil - creche'+#13#10+
            '8512100 - Educação infantil - pré-escola'+#13#10+
            '8513900 - Ensino fundamental'+#13#10+
            '8520100 - Ensino médio'+#13#10+
            '8531700 - Educação superior - graduação'+#13#10+
            '8532500 - Educação superior - graduação e pós-graduação'+#13#10+
            '8533300 - Educação superior - pós-graduação e extensão'+#13#10+
            '8541400 - Educação profissional de nível técnico'+#13#10+
            '8542200 - Educação profissional de nível tecnológico'+#13#10+
            '8550301 - Administração de caixas escolares'+#13#10+
            '8550302 - Atividades de apoio à educação, exceto caixas escolares'+#13#10+
            '8591100 - Ensino de esportes'+#13#10+
            '8592901 - Ensino de dança'+#13#10+
            '8592902 - Ensino de artes cênicas, exceto dança'+#13#10+
            '8592903 - Ensino de música'+#13#10+
            '8592999 - Ensino de arte e cultura não especificado anteriormente'+#13#10+
            '8593700 - Ensino de idiomas'+#13#10+
            '8599601 - Formação de condutores'+#13#10+
            '8599602 - Cursos de pilotagem'+#13#10+
            '8599603 - Treinamento em informática'+#13#10+
            '8599604 - Treinamento em desenvolvimento profissional e gerencial'+#13#10+
            '8599605 - Cursos preparatórios para concursos'+#13#10+
            '8599699 - Outras atividades de ensino não especificadas anteriormente'+#13#10+
            '8610101 - Atividades de atendimento hospitalar, exceto pronto-socorro e unidades para atendimento a urgências'+#13#10+
            '8610102 - Atividades de atendimento em pronto-socorro e unidades hospitalares para atendimento a urgências'+#13#10+
            '8621601 - UTI móvel'+#13#10+
            '8621602 - Serviços móveis de atendimento a urgências, exceto por UTI móvel'+#13#10+
            '8622400 - Serviços de remoção de pacientes, exceto os serviços móveis de atendimento a urgências'+#13#10+
            '8630501 - Atividade médica ambulatorial com recursos para realização de procedimentos cirúrgicos'+#13#10+
            '8630502 - Atividade médica ambulatorial com recursos para realização de exames complementares'+#13#10+
            '8630503 - Atividade médica ambulatorial restrita a consultas'+#13#10+
            '8630504 - Atividade odontológica'+#13#10+
            '8630506 - Serviços de vacinação e imunização humana'+#13#10+
            '8630507 - Atividades de reprodução humana assistida'+#13#10+
            '8630599 - Atividades de atenção ambulatorial não especificadas anteriormente'+#13#10+
            '8640201 - Laboratórios de anatomia patológica e citológica'+#13#10+
            '8640202 - Laboratórios clínicos'+#13#10+
            '8640203 - Serviços de diálise e nefrologia'+#13#10+
            '8640204 - Serviços de tomografia'+#13#10+
            '8640205 - Serviços de diagnóstico por imagem com uso de radiação ionizante, exceto tomografia'+#13#10+
            '8640206 - Serviços de ressonância magnética'+#13#10+
            '8640207 - Serviços de diagnóstico por imagem sem uso de radiação ionizante, exceto ressonância magnética'+#13#10+
            '8640208 - Serviços de diagnóstico por registro gráfico - ECG, EEG e outros exames análogos'+#13#10+
            '8640209 - Serviços de diagnóstico por métodos ópticos - endoscopia e outros exames análogos'+#13#10+
            '8640210 - Serviços de quimioterapia'+#13#10+
            '8640211 - Serviços de radioterapia'+#13#10+
            '8640212 - Serviços de hemoterapia'+#13#10+
            '8640213 - Serviços de litotripsia'+#13#10+
            '8640214 - Serviços de bancos de células e tecidos humanos'+#13#10+
            '8640299 - Atividades de serviços de complementação diagnóstica e terapêutica não especificadas anteriormente'+#13#10+
            '8650001 - Atividades de enfermagem'+#13#10+
            '8650002 - Atividades de profissionais da nutrição'+#13#10+
            '8650003 - Atividades de psicologia e psicanálise'+#13#10+
            '8650004 - Atividades de fisioterapia'+#13#10+
            '8650005 - Atividades de terapia ocupacional'+#13#10+
            '8650006 - Atividades de fonoaudiologia'+#13#10+
            '8650007 - Atividades de terapia de nutrição enteral e parenteral'+#13#10+
            '8650099 - Atividades de profissionais da área de saúde não especificadas anteriormente'+#13#10+
            '8660700 - Atividades de apoio à gestão de saúde'+#13#10+
            '8690901 - Atividades de práticas integrativas e complementares em saúde humana'+#13#10+
            '8690902 - Atividades de bancos de leite humano'+#13#10+
            '8690903 - Atividades de acupuntura'+#13#10+
            '8690904 - Atividades de podologia'+#13#10+
            '8690999 - Outras atividades de atenção à saúde humana não especificadas anteriormente'+#13#10+
            '8711501 - Clínicas e residências geriátricas'+#13#10+
            '8711502 - Instituições de longa permanência para idosos'+#13#10+
            '8711503 - Atividades de assistência a deficientes físicos, imunodeprimidos e convalescentes'+#13#10+
            '8711504 - Centros de apoio a pacientes com câncer e com AIDS'+#13#10+
            '8711505 - Condomínios residenciais para idosos'+#13#10+
            '8712300 - Atividades de fornecimento de infraestrutura de apoio e assistência a paciente no domicílio'+#13#10+
            '8720401 - Atividades de centros de assistência psicossocial'+#13#10+
            '8720499 - Atividades de assistência psicossocial e à saúde a portadores de distúrbios psíquicos, deficiência mental e dependência química e grupos similares não especificadas anteriormente'+#13#10+
            '8730101 - Orfanatos'+#13#10+
            '8730102 - Albergues assistenciais'+#13#10+
            '8730199 - Atividades de assistência social prestadas em residências coletivas e particulares não especificadas anteriormente'+#13#10+
            '8800600 - Serviços de assistência social sem alojamento'+#13#10+
            '9001901 - Produção teatral'+#13#10+
            '9001902 - Produção musical'+#13#10+
            '9001903 - Produção de espetáculos de dança'+#13#10+
            '9001904 - Produção de espetáculos circenses, de marionetes e similares'+#13#10+
            '9001905 - Produção de espetáculos de rodeios, vaquejadas e similares'+#13#10+
            '9001906 - Atividades de sonorização e de iluminação'+#13#10+
            '9001999 - Artes cênicas, espetáculos e atividades complementares não especificados anteriormente'+#13#10+
            '9002701 - Atividades de artistas plásticos, jornalistas independentes e escritores'+#13#10+
            '9002702 - Restauração de obras de arte'+#13#10+
            '9003500 - Gestão de espaços para artes cênicas, espetáculos e outras atividades artísticas'+#13#10+
            '9101500 - Atividades de bibliotecas e arquivos'+#13#10+
            '9102301 - Atividades de museus e de exploração de lugares e prédios históricos e atrações similares'+#13#10+
            '9102302 - Restauração e conservação de lugares e prédios históricos'+#13#10+
            '9103100 - Atividades de jardins botânicos, zoológicos, parques nacionais, reservas ecológicas e áreas de proteção ambiental'+#13#10+
            '9200301 - Casas de bingo'+#13#10+
            '9200302 - Exploração de apostas em corridas de cavalos'+#13#10+
            '9200399 - Exploração de jogos de azar e apostas não especificados anteriormente'+#13#10+
            '9311500 - Gestão de instalações de esportes'+#13#10+
            '9312300 - Clubes sociais, esportivos e similares'+#13#10+
            '9313100 - Atividades de condicionamento físico'+#13#10+
            '9319101 - Produção e promoção de eventos esportivos'+#13#10+
            '9319199 - Outras atividades esportivas não especificadas anteriormente'+#13#10+
            '9321200 - Parques de diversão e parques temáticos'+#13#10+
            '9329801 - Discotecas, danceterias, salões de dança e similares'+#13#10+
            '9329802 - Exploração de boliches'+#13#10+
            '9329803 - Exploração de jogos de sinuca, bilhar e similares'+#13#10+
            '9329804 - Exploração de jogos eletrônicos recreativos'+#13#10+
            '9329899 - Outras atividades de recreação e lazer não especificadas anteriormente'+#13#10+
            '9411100 - Atividades de organizações associativas patronais e empresariais'+#13#10+
            '9412001 - Atividades de fiscalização profissional'+#13#10+
            '9412099 - Outras atividades associativas profissionais'+#13#10+
            '9420100 - Atividades de organizações sindicais'+#13#10+
            '9430800 - Atividades de associações de defesa de direitos sociais'+#13#10+
            '9491000 - Atividades de organizações religiosas ou filosóficas'+#13#10+
            '9492800 - Atividades de organizações políticas'+#13#10+
            '9493600 - Atividades de organizações associativas ligadas à cultura e à arte'+#13#10+
            '9499500 - Atividades associativas não especificadas anteriormente'+#13#10+
            '9511800 - Reparação e manutenção de computadores e de equipamentos periféricos'+#13#10+
            '9512600 - Reparação e manutenção de equipamentos de comunicação'+#13#10+
            '9521500 - Reparação e manutenção de equipamentos eletroeletrônicos de uso pessoal e doméstico'+#13#10+
            '9529101 - Reparação de calçados, bolsas e artigos de viagem'+#13#10+
            '9529102 - Chaveiros'+#13#10+
            '9529103 - Reparação de relógios'+#13#10+
            '9529104 - Reparação de bicicletas, triciclos e outros veículos não motorizados'+#13#10+
            '9529105 - Reparação de artigos do mobiliário'+#13#10+
            '9529106 - Reparação de jóias'+#13#10+
            '9529199 - Reparação e manutenção de outros objetos e equipamentos pessoais e domésticos não especificados anteriormente'+#13#10+
            '9601701 - Lavanderias'+#13#10+
            '9601702 - Tinturarias'+#13#10+
            '9601703 - Toalheiros'+#13#10+
            '9602501 - Cabeleireiros, manicure e pedicure'+#13#10+
            '9602502 - Atividades de estética e outros serviços de cuidados com a beleza'+#13#10+
            '9603301 - Gestão e manutenção de cemitérios'+#13#10+
            '9603302 - Serviços de cremação'+#13#10+
            '9603303 - Serviços de sepultamento'+#13#10+
            '9603304 - Serviços de funerárias'+#13#10+
            '9603305 - Serviços de somatoconservação'+#13#10+
            '9603399 - Atividades funerárias e serviços relacionados não especificados anteriormente'+#13#10+
            '9609202 - Agências matrimoniais'+#13#10+
            '9609204 - Exploração de máquinas de serviços pessoais acionadas por moeda'+#13#10+
            '9609205 - Atividades de sauna e banhos'+#13#10+
            '9609206 - Serviços de tatuagem e colocação de piercing'+#13#10+
            '9609207 - Alojamento de animais domésticos'+#13#10+
            '9609208 - Higiene e embelezamento de animais domésticos'+#13#10+
            '9609299 - Outras atividades de serviços pessoais não especificadas anteriormente'+#13#10+
            '9700500 - Serviços domésticos';
end;

end.
