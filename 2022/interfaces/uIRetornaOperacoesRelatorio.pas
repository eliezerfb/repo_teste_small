unit uIRetornaOperacoesRelatorio;

interface

uses
  IBDatabase, Classes, CheckLst;

type
  IRetornaOperacoesRelatorio = interface
  ['{23F91DC8-081D-4085-9C88-E0B18A9CABF7}']
  function setDataBase(AoDataBase: TIBDatabase): IRetornaOperacoesRelatorio;
  function CarregaDados: IRetornaOperacoesRelatorio;
  function setOperacaoVenda: IRetornaOperacoesRelatorio;
  function setOperacaoCompra: IRetornaOperacoesRelatorio;
  function DefineItens(AoCheckList: TCheckListBox): IRetornaOperacoesRelatorio;
  end;

implementation

end.
