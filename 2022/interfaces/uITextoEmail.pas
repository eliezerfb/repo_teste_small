unit uITextoEmail;

interface

type
  ITextoEmail = interface
  ['{7C059D66-68E3-48B4-BD66-B4E63740249D}']
  function setDataEmissao(AdData: TDateTime): ITextoEmail;
  function setNumeroDocumento(AcNumeroDocumento: String): ITextoEmail;
  function setChaveAcesso(AcChaveAcesso: String): ITextoEmail;
  function RetornarTexto: String;
  end;

implementation

end.
