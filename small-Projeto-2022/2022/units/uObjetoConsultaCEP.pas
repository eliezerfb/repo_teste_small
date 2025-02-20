unit uObjetoConsultaCEP;

interface

type
  TObjetoConsultaCEP = class
  private
    Fcep: String;
    Flogradouro: String;
    Fcomplemento: String;
    Fbairro: String;
    Flocalidade: String;
    Fuf: String;
    Fibge: String;
    Fgia: String;
    Fddd: String;
    Fsiafi: String;
  public
    class function JsonToObject(AcJson: String): TObjetoConsultaCEP;

    // Para adicionar/remover um novo campo retornado pelo JSON
    // basta adicionar/remover a property desejada.

    // Lembrando que a property deve ter o mesmo nome do campo no JSON
    // Metodo JsonToObject irá fazer o trabalho de converte o JSON em Objeto
    property cep: String read Fcep write Fcep;
    property logradouro: String read Flogradouro write Flogradouro;
    property complemento: String read Fcomplemento write Fcomplemento;
    property bairro: String read Fbairro write Fbairro;
    property localidade: String read Flocalidade write Flocalidade;
    property uf: String read Fuf write Fuf;
    property ibge: String read Fibge write Fibge;
    property gia: String read Fgia write Fgia;
    property ddd: String read Fddd write Fddd;
    property siafi: String read Fsiafi write Fsiafi;
  end;

implementation

uses
  REST.Json;

{ TObjetoConsultaCEP }

class function TObjetoConsultaCEP.JsonToObject(AcJson: String): TObjetoConsultaCEP;
begin
  Result := TJson.JsonToObject<TObjetoConsultaCEP>(AcJson);
end;

end.
