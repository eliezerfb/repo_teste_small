program servernfse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  controller.cancel in 'Controllers\controller.cancel.pas',
  controller.search in 'Controllers\controller.search.pas',
  controller.send in 'Controllers\controller.send.pas',
  nfse.classe.cancelamento in 'Classes\nfse.classe.cancelamento.pas',
  nfse.classe.configura_componente in 'Classes\nfse.classe.configura_componente.pas',
  nfse.classe.retorno in 'Classes\nfse.classe.retorno.pas',
  nfse.classe.search in 'Classes\nfse.classe.search.pas',
  nfse.classes.helpers in 'Classes\nfse.classes.helpers.pas',
  nfse.classes.naturezaoperacao in 'Classes\nfse.classes.naturezaoperacao.pas',
  nfse.search.nfserps in 'search\nfse.search.nfserps.pas',
  nfse.checa_resposta in 'Lib\nfse.checa_resposta.pas',
  nfse.checaservico in 'Lib\nfse.checaservico.pas',
  nfse.configura_componente in 'Lib\nfse.configura_componente.pas',
  nfse.classes.regimeespecialtributacao in 'Classes\nfse.classes.regimeespecialtributacao.pas',
  nfse.classes.servico.exigibilidadeiss in 'Classes\nfse.classes.servico.exigibilidadeiss.pas',
  nfse.classes.servico.responsavelretencao in 'Classes\nfse.classes.servico.responsavelretencao.pas',
  nfse.classes.servico.situacaotributaria in 'Classes\nfse.classes.servico.situacaotributaria.pas',
  nfse.classes.servico.tipounidade in 'Classes\nfse.classes.servico.tipounidade.pas',
  nfse.classes.situacaotributacao in 'Classes\nfse.classes.situacaotributacao.pas',
  nfse.classes.statusrps in 'Classes\nfse.classes.statusrps.pas',
  nfse.classes.tiporps in 'Classes\nfse.classes.tiporps.pas',
  nfse.classes.tomador.tipo in 'Classes\nfse.classes.tomador.tipo.pas',
  nfse.classes.nfse in 'Classes\nfse.classes.nfse.pas',
  nfse.retorna_filaws in 'Lib\nfse.retorna_filaws.pas',
  nfse.constants in 'Lib\nfse.constants.pas',
  nfse.envia_xml in 'Lib\nfse.envia_xml.pas',
  nfse.funcoes in 'Lib\nfse.funcoes.pas',
  nfse.jsonerror_resp in 'Lib\nfse.jsonerror_resp.pas',
  controller.status in 'controller.status.pas',
  Pkg.Json.DTO in 'Lib\Pkg.Json.DTO.pas';

begin
  TControllerSend.Registry;
  TControllerCancel.Registry;
  TcontrollerSearch.Registry;
  TcontrollerStatus.Registry;
  THorse.Listen(9000);

end.
