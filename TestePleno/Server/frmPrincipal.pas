unit frmPrincipal;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, Vcl.ExtCtrls,

  LibUtil, ConexaoServer;

type
  TfrmServer = class(TForm)
    btnIniciar: TButton;
    btnParar: TButton;
    edtPorta: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    edtCaminhoBase: TEdit;
    lblCaminhoBase: TLabel;
    procedure btnIniciarClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fConexaoAtiva: Boolean;
    procedure AjustarBotoes;
  end;

var
  frmServer: TfrmServer;

implementation

{$R *.dfm}

uses
  WinApi.Windows, Winapi.ShellApi, Datasnap.DSSession;

procedure TfrmServer.AjustarBotoes;
begin
  btnIniciar.Enabled     := (not fConexaoAtiva);
  edtPorta.Enabled       := (not fConexaoAtiva);
  edtCaminhoBase.Enabled := (not fConexaoAtiva);
  btnParar.Enabled       := fConexaoAtiva;
end;

procedure TfrmServer.btnIniciarClick(Sender: TObject);
begin
  fConexaoAtiva := False;
  try
    DMConexaoServer.PortaTCP  := StrToInt(edtPorta.Text);
    DMConexaoServer.PortaHttp := StrToInt(edtPorta.Text);
    gCaminhoBanco             := edtCaminhoBase.Text;
    fConexaoAtiva             := DMConexaoServer.ConectarServer;

    AjustarBotoes;
  except
    On E: Exception do
      begin
        AjustarBotoes;
        ShowMessage(E.Message);
      end;
  end;
end;


procedure TfrmServer.btnPararClick(Sender: TObject);
begin
  fConexaoAtiva := DMConexaoServer.Desconectar;
  AjustarBotoes;
end;

procedure TfrmServer.FormCreate(Sender: TObject);
begin
  inherited;

  fConexaoAtiva := False;
  AjustarBotoes;
end;


end.
