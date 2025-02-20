unit uclassetiposblocox;

interface

type
  TConfiguracao = record
    ConfCasas: String;
    PerfilPAF: String;
    DiretorioAtual: String;
  end;

  TEmitente = record
    Nome: String;
    CNPJ: String;
    IE: String;
    UF: String;
    Municipio: String;
    Configuracao: TConfiguracao;
  end;

implementation

end.
