unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.CategoryButtons, Vcl.ExtCtrls, uDMImagem, Vcl.WinXCtrls,
  LibUtil;

type
  TfrmPrincipal = class(TForm)
    pnlTopo: TPanel;
    btnMenuLateral: TCategoryButtons;
    spvLateral: TSplitView;
    pnlbarra: TPanel;
    imgGitHub: TImage;
    imgWebSite: TImage;
    imgLinkedIn: TImage;
    imgInstagram: TImage;
    pnlServidorOffline: TPanel;
    procedure btnMenuLateralCategories0Items0Click(Sender: TObject);
    procedure btnMenuLateralCategories0Items1Click(Sender: TObject);
    procedure btnMenuLateralCategories1Items0Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMenuLateralCategories1Items1Click(Sender: TObject);
  private
    procedure StatusServidor;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uFrmPDV, uFrmRelatorioVenda, uFrmCadastroProduto, uFrmCadastroCliente;

{$R *.dfm}

procedure TfrmPrincipal.btnMenuLateralCategories0Items0Click(Sender: TObject);
begin
  Application.CreateForm(TFrmPDV, FrmPDV);
  FrmPDV.Show;
  FrmPDV.BringToFront;
end;

procedure TfrmPrincipal.btnMenuLateralCategories0Items1Click(Sender: TObject);
begin
  Application.CreateForm(TFrmRelatorioVenda, FrmRelatorioVenda);
  FrmRelatorioVenda.Show;
  FrmRelatorioVenda.BringToFront;
end;

procedure TfrmPrincipal.btnMenuLateralCategories1Items0Click(Sender: TObject);
begin
  Application.CreateForm(TFrmCadastroProduto, FrmCadastroProduto);
  FrmCadastroProduto.Visible := True;
  FrmCadastroProduto.Show;
  FrmCadastroProduto.BringToFront;
end;

procedure TfrmPrincipal.btnMenuLateralCategories1Items1Click(Sender: TObject);
begin
  Application.CreateForm(TFrmCadastroCliente, FrmCadastroCliente);
  FrmCadastroCliente.Visible := True;
  FrmCadastroCliente.Show;
  FrmCadastroCliente.BringToFront;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  StatusServidor;
end;

procedure TfrmPrincipal.StatusServidor;
begin
  if (not ArquivoConexao) then
    raise Exception.Create('Arquivo do Server.ini não encontrado! Entre em contato com o desenvolvedor.');

  //pnlServidorOffline.Visible := ;
end;

end.
