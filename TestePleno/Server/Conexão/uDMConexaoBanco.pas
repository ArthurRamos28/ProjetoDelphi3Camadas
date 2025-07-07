unit uDMConexaoBanco;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TDMConexaoBanco = class(TDataModule)
    fdConexao: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
  public
    function Conectar: Boolean;
    function Desconectar: Boolean;
  end;

var
  DMConexaoBanco: TDMConexaoBanco;

implementation

uses
  LibUtil;

{$R *.dfm}

{ TDMConexaoBanco }

function TDMConexaoBanco.Conectar: Boolean;
begin
  Result := False;

  if (not fdConexao.Connected) then
    begin
      if gCaminhoBanco.Trim.IsEmpty then
        raise Exception.Create('Caminho do banco de dados não informado.');

      fdConexao.TxOptions.DisconnectAction    := xdRollback;
      fdConexao.Params.Values['DriverID']     := 'FB';
      fdConexao.Params.Values['CharacterSet'] := 'WIN1252';
      fdConexao.Params.Values['User_Name']    := cgUsuarioBanco;
      fdConexao.Params.Values['Password']     := cgSenhaBanco;
      fdConexao.Params.Values['Database']     := gCaminhoBanco;
      fdConexao.Params.Values['Protocol']     := 'TCPIP';
      fdConexao.Params.Values['Server']       := cgIpBanco;
      fdConexao.Params.Values['Port']         := cgPortaBanco;

      fdConexao.Connected := True;
    end;

  Result := fdConexao.Connected;
end;

function TDMConexaoBanco.Desconectar: Boolean;
begin
  if fdConexao.Connected then
    fdConexao.Connected := False;

  Result := fdConexao.Connected;
end;

end.
