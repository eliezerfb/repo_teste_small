unit LicenseX_TLB;

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

// PASTLWTR : 1.2
// File generated on 16/08/2012 08:42:18 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Windows\SysWOW64\LicenseX.ocx (1)
// LIBID: {D1C38344-AC12-4206-ABF0-78883FCC1CAA}
// LCID: 0
// Helpfile: 
// HelpString: LicenseX Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
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
  LicenseXMajorVersion = 1;
  LicenseXMinorVersion = 0;

  LIBID_LicenseX: TGUID = '{D1C38344-AC12-4206-ABF0-78883FCC1CAA}';

  IID_ISpdLicenseX: TGUID = '{39283A7D-A8A3-4240-95C2-BE3791269875}';
  DIID_ISpdLicenseXEvents: TGUID = '{9F2A1288-D56F-42BD-8F6D-E3ABE6F8DF4C}';
  CLASS_SpdLicenseX: TGUID = '{840799B7-6FE1-4181-8D39-59C49A638D86}';
  IID_ISpdLicenseX2: TGUID = '{BAEB3AAA-1A87-4487-9E6B-E8312AA26AF1}';
  DIID_ISpdLicenseX2Events: TGUID = '{879590E0-F748-4EC7-A9AD-F6DF3C15390B}';
  CLASS_SpdLicenseX2: TGUID = '{215DA8D5-6C87-47B0-B29E-33238008FBDF}';
  IID_ISpdLicenseX3: TGUID = '{A3A6072C-2A84-48F4-94DB-CA111EE062B8}';
  DIID_ISpdLicenseX3Events: TGUID = '{723DA97E-7828-4E5D-9ED0-9F5B978894BA}';
  CLASS_SpdLicenseX3: TGUID = '{A26CD518-F9EB-41A9-8DB7-943903523FE6}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TRegistryRootKey
type
  TRegistryRootKey = TOleEnum;
const
  rkCurrentUser = $00000000;
  rkLocalMachine = $00000001;

// Constants for enum TspdEdocLicense
type
  TspdEdocLicense = TOleEnum;
const
  Free = $00000000;
  Starter = $00000001;
  Professional = $00000002;
  Enterprise = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISpdLicenseX = interface;
  ISpdLicenseXDisp = dispinterface;
  ISpdLicenseXEvents = dispinterface;
  ISpdLicenseX2 = interface;
  ISpdLicenseX2Disp = dispinterface;
  ISpdLicenseX2Events = dispinterface;
  ISpdLicenseX3 = interface;
  ISpdLicenseX3Disp = dispinterface;
  ISpdLicenseX3Events = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SpdLicenseX = ISpdLicenseX;
  SpdLicenseX2 = ISpdLicenseX2;
  SpdLicenseX3 = ISpdLicenseX3;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  TProtectorTypeRec = packed record
    DayTrial: WordBool;
    Password: WordBool;
    Register: WordBool;
    StartTrial: WordBool;
    TimeTrial: WordBool;
  end;

  TProtectorOptionRec = packed record
    AutoInit: WordBool;
    CheckSystemTime: WordBool;
    PasswordOnce: WordBool;
    UseHardwareKey: WordBool;
    UniqueHardwareID: WordBool;
    WorkAfterExpiration: WordBool;
  end;


// *********************************************************************//
// Interface: ISpdLicenseX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {39283A7D-A8A3-4240-95C2-BE3791269875}
// *********************************************************************//
  ISpdLicenseX = interface(IDispatch)
    ['{39283A7D-A8A3-4240-95C2-BE3791269875}']
    function Get_CNPJ: WideString; safecall;
    procedure Set_CNPJ(const Value: WideString); safecall;
    function Get_Servidor: WideString; safecall;
    procedure Set_Servidor(const Value: WideString); safecall;
    function Get_CodigoLicenca: WideString; safecall;
    procedure Set_CodigoLicenca(const Value: WideString); safecall;
    function Get_CodigoProduto: WideString; safecall;
    procedure Set_CodigoProduto(const Value: WideString); safecall;
    function Get_VersaoProduto: WideString; safecall;
    procedure Set_VersaoProduto(const Value: WideString); safecall;
    function Get_MaxTentativas: Smallint; safecall;
    procedure Set_MaxTentativas(Value: Smallint); safecall;
    function Get_DiasContingencia: WideString; safecall;
    function Get_LicencaExpirada: WordBool; safecall;
    procedure Validar(aCachedResult: WordBool); safecall;
    function Get_CaminhoLicenca: WideString; safecall;
    procedure Set_CaminhoLicenca(const Value: WideString); safecall;
    property CNPJ: WideString read Get_CNPJ write Set_CNPJ;
    property Servidor: WideString read Get_Servidor write Set_Servidor;
    property CodigoLicenca: WideString read Get_CodigoLicenca write Set_CodigoLicenca;
    property CodigoProduto: WideString read Get_CodigoProduto write Set_CodigoProduto;
    property VersaoProduto: WideString read Get_VersaoProduto write Set_VersaoProduto;
    property MaxTentativas: Smallint read Get_MaxTentativas write Set_MaxTentativas;
    property DiasContingencia: WideString read Get_DiasContingencia;
    property LicencaExpirada: WordBool read Get_LicencaExpirada;
    property CaminhoLicenca: WideString read Get_CaminhoLicenca write Set_CaminhoLicenca;
  end;

// *********************************************************************//
// DispIntf:  ISpdLicenseXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {39283A7D-A8A3-4240-95C2-BE3791269875}
// *********************************************************************//
  ISpdLicenseXDisp = dispinterface
    ['{39283A7D-A8A3-4240-95C2-BE3791269875}']
    property CNPJ: WideString dispid 201;
    property Servidor: WideString dispid 202;
    property CodigoLicenca: WideString dispid 203;
    property CodigoProduto: WideString dispid 204;
    property VersaoProduto: WideString dispid 205;
    property MaxTentativas: Smallint dispid 206;
    property DiasContingencia: WideString readonly dispid 207;
    property LicencaExpirada: WordBool readonly dispid 208;
    procedure Validar(aCachedResult: WordBool); dispid 209;
    property CaminhoLicenca: WideString dispid 210;
  end;

// *********************************************************************//
// DispIntf:  ISpdLicenseXEvents
// Flags:     (4096) Dispatchable
// GUID:      {9F2A1288-D56F-42BD-8F6D-E3ABE6F8DF4C}
// *********************************************************************//
  ISpdLicenseXEvents = dispinterface
    ['{9F2A1288-D56F-42BD-8F6D-E3ABE6F8DF4C}']
    procedure OnProgress(const aMessage: WideString); dispid 201;
    procedure OnLicencaExpirada; dispid 202;
    procedure OnLicencaValida; dispid 203;
    procedure OnContingencia; dispid 204;
  end;

// *********************************************************************//
// Interface: ISpdLicenseX2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BAEB3AAA-1A87-4487-9E6B-E8312AA26AF1}
// *********************************************************************//
  ISpdLicenseX2 = interface(ISpdLicenseX)
    ['{BAEB3AAA-1A87-4487-9E6B-E8312AA26AF1}']
    function Get_D1: WideString; safecall;
    procedure Set_D1(const Value: WideString); safecall;
    function Get_D2: WideString; safecall;
    procedure Set_D2(const Value: WideString); safecall;
    function Get_ProtectorName: WideString; safecall;
    procedure Set_ProtectorName(const Value: WideString); safecall;
    function Get_CodeKey: WideString; safecall;
    procedure Set_CodeKey(const Value: WideString); safecall;
    function Get_MaxDayNumber: Integer; safecall;
    procedure Set_MaxDayNumber(Value: Integer); safecall;
    function Get_MaxStartNumber: Integer; safecall;
    procedure Set_MaxStartNumber(Value: Integer); safecall;
    function Get_ProtectionType: TProtectorTypeRec; safecall;
    procedure Set_ProtectionType(Value: TProtectorTypeRec); safecall;
    function Get_Options: TProtectorOptionRec; safecall;
    procedure Set_Options(Value: TProtectorOptionRec); safecall;
    function Get_RegistryRootKey: TRegistryRootKey; safecall;
    procedure Set_RegistryRootKey(Value: TRegistryRootKey); safecall;
    procedure Init; safecall;
    property D1: WideString read Get_D1 write Set_D1;
    property D2: WideString read Get_D2 write Set_D2;
    property ProtectorName: WideString read Get_ProtectorName write Set_ProtectorName;
    property CodeKey: WideString read Get_CodeKey write Set_CodeKey;
    property MaxDayNumber: Integer read Get_MaxDayNumber write Set_MaxDayNumber;
    property MaxStartNumber: Integer read Get_MaxStartNumber write Set_MaxStartNumber;
    property ProtectionType: TProtectorTypeRec read Get_ProtectionType write Set_ProtectionType;
    property Options: TProtectorOptionRec read Get_Options write Set_Options;
    property RegistryRootKey: TRegistryRootKey read Get_RegistryRootKey write Set_RegistryRootKey;
  end;

// *********************************************************************//
// DispIntf:  ISpdLicenseX2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BAEB3AAA-1A87-4487-9E6B-E8312AA26AF1}
// *********************************************************************//
  ISpdLicenseX2Disp = dispinterface
    ['{BAEB3AAA-1A87-4487-9E6B-E8312AA26AF1}']
    property D1: WideString dispid 301;
    property D2: WideString dispid 302;
    property ProtectorName: WideString dispid 303;
    property CodeKey: WideString dispid 304;
    property MaxDayNumber: Integer dispid 305;
    property MaxStartNumber: Integer dispid 306;
    property ProtectionType: {??TProtectorTypeRec}OleVariant dispid 307;
    property Options: {??TProtectorOptionRec}OleVariant dispid 308;
    property RegistryRootKey: TRegistryRootKey dispid 309;
    procedure Init; dispid 310;
    property CNPJ: WideString dispid 201;
    property Servidor: WideString dispid 202;
    property CodigoLicenca: WideString dispid 203;
    property CodigoProduto: WideString dispid 204;
    property VersaoProduto: WideString dispid 205;
    property MaxTentativas: Smallint dispid 206;
    property DiasContingencia: WideString readonly dispid 207;
    property LicencaExpirada: WordBool readonly dispid 208;
    procedure Validar(aCachedResult: WordBool); dispid 209;
    property CaminhoLicenca: WideString dispid 210;
  end;

// *********************************************************************//
// DispIntf:  ISpdLicenseX2Events
// Flags:     (4096) Dispatchable
// GUID:      {879590E0-F748-4EC7-A9AD-F6DF3C15390B}
// *********************************************************************//
  ISpdLicenseX2Events = dispinterface
    ['{879590E0-F748-4EC7-A9AD-F6DF3C15390B}']
    procedure OnDayTrial(DaysRemained: Integer); dispid 201;
    procedure OnStartTrial(StartsRemained: Integer); dispid 202;
    procedure OnInvalidSystemTime; dispid 203;
    procedure OnExpiration; dispid 204;
    procedure OnProgress(const aMessage: WideString); dispid 205;
    procedure OnLicencaExpirada; dispid 206;
    procedure OnLicencaValida; dispid 207;
    procedure OnContingencia; dispid 208;
  end;

// *********************************************************************//
// Interface: ISpdLicenseX3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A3A6072C-2A84-48F4-94DB-CA111EE062B8}
// *********************************************************************//
  ISpdLicenseX3 = interface(IDispatch)
    ['{A3A6072C-2A84-48F4-94DB-CA111EE062B8}']
    function Get_CNPJ: WideString; safecall;
    procedure Set_CNPJ(const Value: WideString); safecall;
    function Get_CodigoProduto: WideString; safecall;
    procedure Set_CodigoProduto(const Value: WideString); safecall;
    function Get_Servidor: WideString; safecall;
    procedure Set_Servidor(const Value: WideString); safecall;
    function Get_ServidorContingencia: WideString; safecall;
    procedure Set_ServidorContingencia(const Value: WideString); safecall;
    function Get_CaminhoLicenca: WideString; safecall;
    procedure Set_CaminhoLicenca(const Value: WideString); safecall;
    function Get_AccountKey: WideString; safecall;
    procedure Set_AccountKey(const Value: WideString); safecall;
    function Get_AccountSecret: WideString; safecall;
    procedure Set_AccountSecret(const Value: WideString); safecall;
    procedure Validar(aCachedResult: WordBool); safecall;
    function NivelLicenca: TspdEdocLicense; safecall;
    function Get_MaxTentativas: Integer; safecall;
    procedure Set_MaxTentativas(Value: Integer); safecall;
    property CNPJ: WideString read Get_CNPJ write Set_CNPJ;
    property CodigoProduto: WideString read Get_CodigoProduto write Set_CodigoProduto;
    property Servidor: WideString read Get_Servidor write Set_Servidor;
    property ServidorContingencia: WideString read Get_ServidorContingencia write Set_ServidorContingencia;
    property CaminhoLicenca: WideString read Get_CaminhoLicenca write Set_CaminhoLicenca;
    property AccountKey: WideString read Get_AccountKey write Set_AccountKey;
    property AccountSecret: WideString read Get_AccountSecret write Set_AccountSecret;
    property MaxTentativas: Integer read Get_MaxTentativas write Set_MaxTentativas;
  end;

// *********************************************************************//
// DispIntf:  ISpdLicenseX3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A3A6072C-2A84-48F4-94DB-CA111EE062B8}
// *********************************************************************//
  ISpdLicenseX3Disp = dispinterface
    ['{A3A6072C-2A84-48F4-94DB-CA111EE062B8}']
    property CNPJ: WideString dispid 205;
    property CodigoProduto: WideString dispid 206;
    property Servidor: WideString dispid 207;
    property ServidorContingencia: WideString dispid 210;
    property CaminhoLicenca: WideString dispid 211;
    property AccountKey: WideString dispid 201;
    property AccountSecret: WideString dispid 212;
    procedure Validar(aCachedResult: WordBool); dispid 202;
    function NivelLicenca: TspdEdocLicense; dispid 203;
    property MaxTentativas: Integer dispid 204;
  end;

// *********************************************************************//
// DispIntf:  ISpdLicenseX3Events
// Flags:     (4096) Dispatchable
// GUID:      {723DA97E-7828-4E5D-9ED0-9F5B978894BA}
// *********************************************************************//
  ISpdLicenseX3Events = dispinterface
    ['{723DA97E-7828-4E5D-9ED0-9F5B978894BA}']
    procedure OnLicencaExpirada; dispid 201;
    procedure OnLicencaValida; dispid 202;
    procedure OnContingencia; dispid 203;
    procedure OnProgress(const aMessage: WideString); dispid 204;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TSpdLicenseX
// Help String      : SpdLicenseX Control
// Default Interface: ISpdLicenseX
// Def. Intf. DISP? : No
// Event   Interface: ISpdLicenseXEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TSpdLicenseXOnProgress = procedure(ASender: TObject; const aMessage: WideString) of object;

  TSpdLicenseX = class(TOleControl)
  private
    FOnProgress: TSpdLicenseXOnProgress;
    FOnLicencaExpirada: TNotifyEvent;
    FOnLicencaValida: TNotifyEvent;
    FOnContingencia: TNotifyEvent;
    FIntf: ISpdLicenseX;
    function  GetControlInterface: ISpdLicenseX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Validar(aCachedResult: WordBool);
    property  ControlInterface: ISpdLicenseX read GetControlInterface;
    property  DefaultInterface: ISpdLicenseX read GetControlInterface;
    property DiasContingencia: WideString index 207 read GetWideStringProp;
    property LicencaExpirada: WordBool index 208 read GetWordBoolProp;
  published
    property Anchors;
    property CNPJ: WideString index 201 read GetWideStringProp write SetWideStringProp stored False;
    property Servidor: WideString index 202 read GetWideStringProp write SetWideStringProp stored False;
    property CodigoLicenca: WideString index 203 read GetWideStringProp write SetWideStringProp stored False;
    property CodigoProduto: WideString index 204 read GetWideStringProp write SetWideStringProp stored False;
    property VersaoProduto: WideString index 205 read GetWideStringProp write SetWideStringProp stored False;
    property MaxTentativas: Smallint index 206 read GetSmallintProp write SetSmallintProp stored False;
    property CaminhoLicenca: WideString index 210 read GetWideStringProp write SetWideStringProp stored False;
    property OnProgress: TSpdLicenseXOnProgress read FOnProgress write FOnProgress;
    property OnLicencaExpirada: TNotifyEvent read FOnLicencaExpirada write FOnLicencaExpirada;
    property OnLicencaValida: TNotifyEvent read FOnLicencaValida write FOnLicencaValida;
    property OnContingencia: TNotifyEvent read FOnContingencia write FOnContingencia;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TSpdLicenseX2
// Help String      : 
// Default Interface: ISpdLicenseX2
// Def. Intf. DISP? : No
// Event   Interface: ISpdLicenseX2Events
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TSpdLicenseX2OnDayTrial = procedure(ASender: TObject; DaysRemained: Integer) of object;
  TSpdLicenseX2OnStartTrial = procedure(ASender: TObject; StartsRemained: Integer) of object;
  TSpdLicenseX2OnProgress = procedure(ASender: TObject; const aMessage: WideString) of object;

  TSpdLicenseX2 = class(TOleControl)
  private
    FOnDayTrial: TSpdLicenseX2OnDayTrial;
    FOnStartTrial: TSpdLicenseX2OnStartTrial;
    FOnInvalidSystemTime: TNotifyEvent;
    FOnExpiration: TNotifyEvent;
    FOnProgress: TSpdLicenseX2OnProgress;
    FOnLicencaExpirada: TNotifyEvent;
    FOnLicencaValida: TNotifyEvent;
    FOnContingencia: TNotifyEvent;
    FIntf: ISpdLicenseX2;
    function  GetControlInterface: ISpdLicenseX2;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_ProtectionType: TProtectorTypeRec;
    procedure Set_ProtectionType(Value: TProtectorTypeRec);
    function Get_Options: TProtectorOptionRec;
    procedure Set_Options(Value: TProtectorOptionRec);
  public
    procedure Validar(aCachedResult: WordBool);
    procedure Init;
    property  ControlInterface: ISpdLicenseX2 read GetControlInterface;
    property  DefaultInterface: ISpdLicenseX2 read GetControlInterface;
    property DiasContingencia: WideString index 207 read GetWideStringProp;
    property LicencaExpirada: WordBool index 208 read GetWordBoolProp;
  published
    property Anchors;
    property CNPJ: WideString index 201 read GetWideStringProp write SetWideStringProp stored False;
    property Servidor: WideString index 202 read GetWideStringProp write SetWideStringProp stored False;
    property CodigoLicenca: WideString index 203 read GetWideStringProp write SetWideStringProp stored False;
    property CodigoProduto: WideString index 204 read GetWideStringProp write SetWideStringProp stored False;
    property VersaoProduto: WideString index 205 read GetWideStringProp write SetWideStringProp stored False;
    property MaxTentativas: Smallint index 206 read GetSmallintProp write SetSmallintProp stored False;
    property CaminhoLicenca: WideString index 210 read GetWideStringProp write SetWideStringProp stored False;
    property D1: WideString index 301 read GetWideStringProp write SetWideStringProp stored False;
    property D2: WideString index 302 read GetWideStringProp write SetWideStringProp stored False;
    property ProtectorName: WideString index 303 read GetWideStringProp write SetWideStringProp stored False;
    property CodeKey: WideString index 304 read GetWideStringProp write SetWideStringProp stored False;
    property MaxDayNumber: Integer index 305 read GetIntegerProp write SetIntegerProp stored False;
    property MaxStartNumber: Integer index 306 read GetIntegerProp write SetIntegerProp stored False;
    property ProtectionType: TProtectorTypeRec read Get_ProtectionType write Set_ProtectionType stored False;
    property Options: TProtectorOptionRec read Get_Options write Set_Options stored False;
    property RegistryRootKey: TOleEnum index 309 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property OnDayTrial: TSpdLicenseX2OnDayTrial read FOnDayTrial write FOnDayTrial;
    property OnStartTrial: TSpdLicenseX2OnStartTrial read FOnStartTrial write FOnStartTrial;
    property OnInvalidSystemTime: TNotifyEvent read FOnInvalidSystemTime write FOnInvalidSystemTime;
    property OnExpiration: TNotifyEvent read FOnExpiration write FOnExpiration;
    property OnProgress: TSpdLicenseX2OnProgress read FOnProgress write FOnProgress;
    property OnLicencaExpirada: TNotifyEvent read FOnLicencaExpirada write FOnLicencaExpirada;
    property OnLicencaValida: TNotifyEvent read FOnLicencaValida write FOnLicencaValida;
    property OnContingencia: TNotifyEvent read FOnContingencia write FOnContingencia;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TSpdLicenseX3
// Help String      : 
// Default Interface: ISpdLicenseX3
// Def. Intf. DISP? : No
// Event   Interface: ISpdLicenseX3Events
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TSpdLicenseX3OnProgress = procedure(ASender: TObject; const aMessage: WideString) of object;

  TSpdLicenseX3 = class(TOleControl)
  private
    FOnLicencaExpirada: TNotifyEvent;
    FOnLicencaValida: TNotifyEvent;
    FOnContingencia: TNotifyEvent;
    FOnProgress: TSpdLicenseX3OnProgress;
    FIntf: ISpdLicenseX3;
    function  GetControlInterface: ISpdLicenseX3;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Validar(aCachedResult: WordBool);
    function NivelLicenca: TspdEdocLicense;
    property  ControlInterface: ISpdLicenseX3 read GetControlInterface;
    property  DefaultInterface: ISpdLicenseX3 read GetControlInterface;
  published
    property Anchors;
    property CNPJ: WideString index 205 read GetWideStringProp write SetWideStringProp stored False;
    property CodigoProduto: WideString index 206 read GetWideStringProp write SetWideStringProp stored False;
    property Servidor: WideString index 207 read GetWideStringProp write SetWideStringProp stored False;
    property ServidorContingencia: WideString index 210 read GetWideStringProp write SetWideStringProp stored False;
    property CaminhoLicenca: WideString index 211 read GetWideStringProp write SetWideStringProp stored False;
    property AccountKey: WideString index 201 read GetWideStringProp write SetWideStringProp stored False;
    property AccountSecret: WideString index 212 read GetWideStringProp write SetWideStringProp stored False;
    property MaxTentativas: Integer index 204 read GetIntegerProp write SetIntegerProp stored False;
    property OnLicencaExpirada: TNotifyEvent read FOnLicencaExpirada write FOnLicencaExpirada;
    property OnLicencaValida: TNotifyEvent read FOnLicencaValida write FOnLicencaValida;
    property OnContingencia: TNotifyEvent read FOnContingencia write FOnContingencia;
    property OnProgress: TSpdLicenseX3OnProgress read FOnProgress write FOnProgress;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TSpdLicenseX.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $000000C9, $000000CA, $000000CB, $000000CC);
  CLicenseKey: array[0..38] of Word = ( $007B, $0044, $0041, $0038, $0038, $0036, $0042, $0044, $0039, $002D, $0044
    , $0036, $0041, $0046, $002D, $0034, $0036, $0036, $0035, $002D, $0042
    , $0031, $0033, $0033, $002D, $0034, $0032, $0037, $0043, $0041, $0042
    , $0042, $0037, $0031, $0037, $0046, $0041, $007D, $0000);
  CControlData: TControlData2 = (
    ClassID: '{840799B7-6FE1-4181-8D39-59C49A638D86}';
    EventIID: '{9F2A1288-D56F-42BD-8F6D-E3ABE6F8DF4C}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnProgress) - Cardinal(Self);
end;

procedure TSpdLicenseX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISpdLicenseX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TSpdLicenseX.GetControlInterface: ISpdLicenseX;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TSpdLicenseX.Validar(aCachedResult: WordBool);
begin
  DefaultInterface.Validar(aCachedResult);
end;

procedure TSpdLicenseX2.InitControlData;
const
  CEventDispIDs: array [0..7] of DWORD = (
    $000000C9, $000000CA, $000000CB, $000000CC, $000000CD, $000000CE,
    $000000CF, $000000D0);
  CLicenseKey: array[0..38] of Word = ( $007B, $0044, $0041, $0038, $0038, $0036, $0042, $0044, $0039, $002D, $0044
    , $0036, $0041, $0046, $002D, $0034, $0036, $0036, $0035, $002D, $0042
    , $0031, $0033, $0033, $002D, $0034, $0032, $0037, $0043, $0041, $0042
    , $0042, $0037, $0031, $0037, $0046, $0041, $007D, $0000);
  CControlData: TControlData2 = (
    ClassID: '{215DA8D5-6C87-47B0-B29E-33238008FBDF}';
    EventIID: '{879590E0-F748-4EC7-A9AD-F6DF3C15390B}';
    EventCount: 8;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnDayTrial) - Cardinal(Self);
end;

procedure TSpdLicenseX2.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISpdLicenseX2;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TSpdLicenseX2.GetControlInterface: ISpdLicenseX2;
begin
  CreateControl;
  Result := FIntf;
end;

function TSpdLicenseX2.Get_ProtectionType: TProtectorTypeRec;
begin
    Result := DefaultInterface.ProtectionType;
end;

procedure TSpdLicenseX2.Set_ProtectionType(Value: TProtectorTypeRec);
begin
  DefaultInterface.Set_ProtectionType(Value);
end;

function TSpdLicenseX2.Get_Options: TProtectorOptionRec;
begin
    Result := DefaultInterface.Options;
end;

procedure TSpdLicenseX2.Set_Options(Value: TProtectorOptionRec);
begin
  DefaultInterface.Set_Options(Value);
end;

procedure TSpdLicenseX2.Validar(aCachedResult: WordBool);
begin
  DefaultInterface.Validar(aCachedResult);
end;

procedure TSpdLicenseX2.Init;
begin
  DefaultInterface.Init;
end;

procedure TSpdLicenseX3.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $000000C9, $000000CA, $000000CB, $000000CC);
  CLicenseKey: array[0..38] of Word = ( $007B, $0044, $0041, $0038, $0038, $0036, $0042, $0044, $0039, $002D, $0044
    , $0036, $0041, $0046, $002D, $0034, $0036, $0036, $0035, $002D, $0042
    , $0031, $0033, $0033, $002D, $0034, $0032, $0037, $0043, $0041, $0042
    , $0042, $0037, $0031, $0037, $0046, $0041, $007D, $0000);
  CControlData: TControlData2 = (
    ClassID: '{A26CD518-F9EB-41A9-8DB7-943903523FE6}';
    EventIID: '{723DA97E-7828-4E5D-9ED0-9F5B978894BA}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnLicencaExpirada) - Cardinal(Self);
end;

procedure TSpdLicenseX3.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISpdLicenseX3;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TSpdLicenseX3.GetControlInterface: ISpdLicenseX3;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TSpdLicenseX3.Validar(aCachedResult: WordBool);
begin
  DefaultInterface.Validar(aCachedResult);
end;

function TSpdLicenseX3.NivelLicenca: TspdEdocLicense;
begin
  Result := DefaultInterface.NivelLicenca;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TSpdLicenseX, TSpdLicenseX2, TSpdLicenseX3]);
end;

end.
