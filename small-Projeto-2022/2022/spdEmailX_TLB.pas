unit spdEmailX_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 34747 $
// File generated on 07/12/2011 09:13:50 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Windows\System32\spdEmailX.ocx (1)
// LIBID: {DB331E51-F37A-462F-8812-1B539D361D15}
// LCID: 0
// Helpfile: 
// HelpString: spdEmailX Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  spdEmailXMajorVersion = 1;
  spdEmailXMinorVersion = 0;

  LIBID_spdEmailX: TGUID = '{DB331E51-F37A-462F-8812-1B539D361D15}';

  IID_IspdEmailX: TGUID = '{6C4AA1BB-AFB0-4EAF-98FE-668004319198}';
  DIID_IspdEmailXEvents: TGUID = '{DB58B78D-60FD-47C1-B951-175C95E38C00}';
  CLASS_spdEmail: TGUID = '{7368B5E6-71BA-4374-8078-35B4F07D3C93}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IspdEmailX = interface;
  IspdEmailXDisp = dispinterface;
  IspdEmailXEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  spdEmail = IspdEmailX;


// *********************************************************************//
// Interface: IspdEmailX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C4AA1BB-AFB0-4EAF-98FE-668004319198}
// *********************************************************************//
  IspdEmailX = interface(IDispatch)
    ['{6C4AA1BB-AFB0-4EAF-98FE-668004319198}']
    function Get_EmailRemetente: WideString; safecall;
    procedure Set_EmailRemetente(const Value: WideString); safecall;
    function Get_ServidorSMTP: WideString; safecall;
    procedure Set_ServidorSMTP(const Value: WideString); safecall;
    function Get_Senha: WideString; safecall;
    procedure Set_Senha(const Value: WideString); safecall;
    function Get_Usuario: WideString; safecall;
    procedure Set_Usuario(const Value: WideString); safecall;
    function Get_Assunto: WideString; safecall;
    procedure Set_Assunto(const Value: WideString); safecall;
    function Get_Mensagem: WideString; safecall;
    procedure Set_Mensagem(const Value: WideString); safecall;
    function Get_Autenticacao: WordBool; safecall;
    procedure Set_Autenticacao(Value: WordBool); safecall;
    function Get_Porta: Integer; safecall;
    procedure Set_Porta(Value: Integer); safecall;
    function Get_CCo: WideString; safecall;
    procedure Set_CCo(const Value: WideString); safecall;
    function Get_CC: WideString; safecall;
    procedure Set_CC(const Value: WideString); safecall;
    function Get_TimeOut: Integer; safecall;
    procedure Set_TimeOut(Value: Integer); safecall;
    function Get_Apelido: WideString; safecall;
    procedure Enviar(const aEmailDestinatario: WideString; const aAnexos: WideString); safecall;
    property EmailRemetente: WideString read Get_EmailRemetente write Set_EmailRemetente;
    property ServidorSMTP: WideString read Get_ServidorSMTP write Set_ServidorSMTP;
    property Senha: WideString read Get_Senha write Set_Senha;
    property Usuario: WideString read Get_Usuario write Set_Usuario;
    property Assunto: WideString read Get_Assunto write Set_Assunto;
    property Mensagem: WideString read Get_Mensagem write Set_Mensagem;
    property Autenticacao: WordBool read Get_Autenticacao write Set_Autenticacao;
    property Porta: Integer read Get_Porta write Set_Porta;
    property CCo: WideString read Get_CCo write Set_CCo;
    property CC: WideString read Get_CC write Set_CC;
    property TimeOut: Integer read Get_TimeOut write Set_TimeOut;
    property Apelido: WideString read Get_Apelido;
  end;

// *********************************************************************//
// DispIntf:  IspdEmailXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C4AA1BB-AFB0-4EAF-98FE-668004319198}
// *********************************************************************//
  IspdEmailXDisp = dispinterface
    ['{6C4AA1BB-AFB0-4EAF-98FE-668004319198}']
    property EmailRemetente: WideString dispid 201;
    property ServidorSMTP: WideString dispid 202;
    property Senha: WideString dispid 203;
    property Usuario: WideString dispid 204;
    property Assunto: WideString dispid 205;
    property Mensagem: WideString dispid 206;
    property Autenticacao: WordBool dispid 207;
    property Porta: Integer dispid 208;
    property CCo: WideString dispid 209;
    property CC: WideString dispid 210;
    property TimeOut: Integer dispid 211;
    property Apelido: WideString readonly dispid 212;
    procedure Enviar(const aEmailDestinatario: WideString; const aAnexos: WideString); dispid 213;
  end;

// *********************************************************************//
// DispIntf:  IspdEmailXEvents
// Flags:     (4096) Dispatchable
// GUID:      {DB58B78D-60FD-47C1-B951-175C95E38C00}
// *********************************************************************//
  IspdEmailXEvents = dispinterface
    ['{DB58B78D-60FD-47C1-B951-175C95E38C00}']
    procedure OnProgress(const aMessage: WideString); dispid 202;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TspdEmail
// Help String      : spdEmailX Control
// Default Interface: IspdEmailX
// Def. Intf. DISP? : No
// Event   Interface: IspdEmailXEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TspdEmailOnProgress = procedure(ASender: TObject; const aMessage: WideString) of object;

  TspdEmail = class(TOleControl)
  private
    FOnProgress: TspdEmailOnProgress;
    FIntf: IspdEmailX;
    function  GetControlInterface: IspdEmailX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Enviar(const aEmailDestinatario: WideString; const aAnexos: WideString);
    property  ControlInterface: IspdEmailX read GetControlInterface;
    property  DefaultInterface: IspdEmailX read GetControlInterface;
    property Apelido: WideString index 212 read GetWideStringProp;
  published
    property Anchors;
    property EmailRemetente: WideString index 201 read GetWideStringProp write SetWideStringProp stored False;
    property ServidorSMTP: WideString index 202 read GetWideStringProp write SetWideStringProp stored False;
    property Senha: WideString index 203 read GetWideStringProp write SetWideStringProp stored False;
    property Usuario: WideString index 204 read GetWideStringProp write SetWideStringProp stored False;
    property Assunto: WideString index 205 read GetWideStringProp write SetWideStringProp stored False;
    property Mensagem: WideString index 206 read GetWideStringProp write SetWideStringProp stored False;
    property Autenticacao: WordBool index 207 read GetWordBoolProp write SetWordBoolProp stored False;
    property Porta: Integer index 208 read GetIntegerProp write SetIntegerProp stored False;
    property CCo: WideString index 209 read GetWideStringProp write SetWideStringProp stored False;
    property CC: WideString index 210 read GetWideStringProp write SetWideStringProp stored False;
    property TimeOut: Integer index 211 read GetIntegerProp write SetIntegerProp stored False;
    property OnProgress: TspdEmailOnProgress read FOnProgress write FOnProgress;
  end;

//procedure Register;

resourcestring
  dtlServerPage = 'Tecnospeed Utils';

  dtlOcxPage = 'Tecnospeed Utils';

implementation

uses ComObj;

procedure TspdEmail.InitControlData;
const
  CEventDispIDs: array [0..0] of DWORD = (
    $000000CA);
  CControlData: TControlData2 = (
    ClassID: '{7368B5E6-71BA-4374-8078-35B4F07D3C93}';
    EventIID: '{DB58B78D-60FD-47C1-B951-175C95E38C00}';
    EventCount: 1;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80040112*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnProgress) - Cardinal(Self);
end;

procedure TspdEmail.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IspdEmailX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TspdEmail.GetControlInterface: IspdEmailX;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TspdEmail.Enviar(const aEmailDestinatario: WideString; const aAnexos: WideString);
begin
  DefaultInterface.Enviar(aEmailDestinatario, aAnexos);
end;

{procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TspdEmail]);
end;}

end.
