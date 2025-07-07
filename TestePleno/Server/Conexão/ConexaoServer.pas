unit ConexaoServer;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSCommonServer, IPPeerServer, IPPeerAPI, Datasnap.DSAuth,
  Datasnap.DSHTTP, Datasnap.DSHTTPCommon, Data.DBXPlatform, System.Generics.Collections, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,

  Rotabase;

type
  TDMConexaoServer = class(TDataModule)
    DSServer: TDSServer;
    DSAuthenticationManager: TDSAuthenticationManager;
    DSHTTPService: TDSHTTPService;
    procedure DSAuthenticationManagerUserAuthorize(Sender: TObject; EventObject: TDSAuthorizeEventObject; var valid: Boolean);
    procedure DSAuthenticationManagerUserAuthenticate(Sender: TObject; const Protocol, Context, User, Password: string;
      var valid: Boolean; UserRoles: TStrings);
    procedure DataModuleCreate(Sender: TObject);
    procedure DSHTTPServiceHTTPTrace(Sender: TObject; AContext: TDSHTTPContext; ARequest: TDSHTTPRequest;
      AResponse: TDSHTTPResponse);
  private
    FPortaTCP: Integer;
    FPortaHttp: Integer;
    FDSHTTPSServiceRest: TDSHTTPService;
    function GetPortaTCP: Integer;
    procedure SetPortaTCP(const Value: Integer);
    function GetPortaHttp: Integer;
    procedure SetPortaHttp(const Value: Integer);
  public
    function ConectarServer: Boolean;
    function Desconectar: Boolean;
  published
    property PortaTCP: Integer read GetPortaTCP write SetPortaTCP;
    property PortaHttp: Integer read GetPortaHttp write SetPortaHttp;
  end;

var
  DMConexaoServer: TDMConexaoServer;

implementation

uses
  uDMConexaoBanco;

{$R *.dfm}

function TDMConexaoServer.ConectarServer: Boolean;
begin
  if Assigned(DSServer) then
    DSServer.Stop;

  FDSHTTPSServiceRest.DSPort      := PortaTCP;
  FDSHTTPSServiceRest.HttpPort    := PortaHttp;
  FDSHTTPSServiceRest.OnHTTPTrace := DSHTTPServiceHTTPTrace;
  DSServer.Start;

  Result := DMConexaoBanco.Conectar;
end;
procedure TDMConexaoServer.DataModuleCreate(Sender: TObject);
begin
  inherited;

  PortaTCP                   := 0;
  PortaHttp                  := 0;
  //FDSAuthenticationManager   := DSAuthenticationManager;
  FDSHTTPSServiceRest        := TDSHTTPService.Create(DSServer);
  FDSHTTPSServiceRest.Server := DSServer;
end;

function TDMConexaoServer.Desconectar: Boolean;
begin
 //FDSAuthenticationManager := nil;

  if Assigned(DSServer) then
    DSServer.Stop;

  Result := DMConexaoBanco.Desconectar;
end;

procedure TDMConexaoServer.DSAuthenticationManagerUserAuthenticate(
  Sender: TObject; const Protocol, Context, User, Password: string;
  var valid: Boolean; UserRoles: TStrings);
begin
  { TODO : Validate the client user and password.
    If role-based authorization is needed, add role names to the UserRoles parameter  }
  valid := True;
end;

procedure TDMConexaoServer.DSAuthenticationManagerUserAuthorize(
  Sender: TObject; EventObject: TDSAuthorizeEventObject;
  var valid: Boolean);
begin
  { TODO : Authorize a user to execute a method.
    Use values from EventObject such as UserName, UserRoles, AuthorizedRoles and DeniedRoles.
    Use DSAuthenticationManager1.Roles to define Authorized and Denied roles
    for particular server methods. }
  valid := True;
end;

procedure TDMConexaoServer.DSHTTPServiceHTTPTrace(Sender: TObject; AContext: TDSHTTPContext; ARequest: TDSHTTPRequest;
  AResponse: TDSHTTPResponse);
begin
  gRotaBase.Execute(ARequest, AResponse);
end;

function TDMConexaoServer.GetPortaHttp: Integer;
begin
  Result := FPortaHttp;
end;

function TDMConexaoServer.GetPortaTCP: Integer;
begin
  Result := FPortaTCP;
end;

procedure TDMConexaoServer.SetPortaHttp(const Value: Integer);
begin
  FPortaHttp := Value;
end;

procedure TDMConexaoServer.SetPortaTCP(const Value: Integer);
begin
  FPortaTCP := Value;
end;

end.

