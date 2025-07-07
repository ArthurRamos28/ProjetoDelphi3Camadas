unit uFrmCadastroProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmCadastroBase, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.Menus,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  JvExDBGrids, JvDBGrid, Vcl.ComCtrls,

  fraBotaoDuplo, LibUtil;

type
  TFrmCadastroProduto = class(TfrmCadastroBase)
    edtID: TEdit;
    edtNome: TEdit;
    mmoDescricao: TMemo;
    chkAtivo: TCheckBox;
    edtPreco: TEdit;
    FraBotao: TufraBotaoDuplo;
    pnlBarra: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FraBotaobtnOkClick(Sender: TObject);
    procedure FraBotaobtnSairClick(Sender: TObject);
    procedure pmiClonarClick(Sender: TObject);
    procedure grdConsultaDblClick(Sender: TObject);
  private
    fNome: String;
    fIdProduto: Integer;
    fValorUnitario: Double;

    procedure LimparCampos;
    procedure CarregarGrid; override;
    procedure CarregarCadastro; override;
    procedure AjustarNomeBotao;
    function VerificaAlteracao: Boolean;
    procedure Salvar; override;
    procedure AjustarTela(mConsulta: Boolean = True);
    function ValidarCadastro: Boolean;
    function GetIdProduto: Integer;
    function GetNome: String;
    procedure SetIdProduto(const Value: Integer);
    procedure SetNome(const Value: String);
    function GetValorUnitario: Double;
    procedure SetValorUnitario(const Value: Double);
  public

    property Nome: String read GetNome write SetNome;
    property IdProduto: Integer read GetIdProduto write SetIdProduto;
    property ValorUnitario: Double read GetValorUnitario write SetValorUnitario;
  end;

var
  FrmCadastroProduto: TFrmCadastroProduto;

implementation

{$R *.dfm}

procedure TFrmCadastroProduto.CarregarCadastro;
begin
  inherited;

  if (fSituacaoCadastro in [scaAlterando, scaClonando]) then
    begin
      if (fSituacaoCadastro = scaAlterando) then
       edtID.Text := fmtConsulta.FieldByName('Id').AsInteger.ToString;

      edtNome.Text     := fmtConsulta.FieldByName('Nome').AsString;
      edtPreco.Text    := FormatFloat('#,##0.00', fmtConsulta.FieldByName('Preco').AsFloat);
      chkAtivo.Checked := fmtConsulta.FieldByName('Ativo').AsBoolean;
      mmoDescricao.Lines.Add(fmtConsulta.FieldByName('Descricao').AsString);
    end
  else
    LimparCampos;

  AjustarNomeBotao;
end;

procedure TFrmCadastroProduto.CarregarGrid;
begin
  inherited;

  grdConsulta.Columns[1].FieldName := 'Id';
  grdConsulta.Columns[2].FieldName := 'Nome';
end;

procedure TFrmCadastroProduto.FormCreate(Sender: TObject);
begin
  fTabela := 'Produto';
 
  inherited;

  AjustarNomeBotao;
end;

procedure TFrmCadastroProduto.AjustarTela(mConsulta: Boolean = True);
begin
  if mConsulta then
    begin
      pgcGeral.ActivePage := tsConsulta;
      fSituacaoCadastro   := scaNenhum;
      LimparCampos;
    end
  else
    pgcGeral.ActivePage := tsCadastro;

  AjustarNomeBotao;
end;

procedure TFrmCadastroProduto.FraBotaobtnOkClick(Sender: TObject);
begin
  inherited;

  if (pgcGeral.ActivePage = tsConsulta) then
    AjustarTela(False)
  else if (pgcGeral.ActivePage = tsCadastro) and (VerificaAlteracao or (fSituacaoCadastro = scaClonando)) then
    Salvar
  else if fPesquisando then
    AjustarTela(False)
  else
    FraBotaobtnSairClick(nil);
end;

procedure TFrmCadastroProduto.FraBotaobtnSairClick(Sender: TObject);
begin
  inherited;

  if (pgcGeral.ActivePage = tsCadastro) then
    AjustarTela
  else
    Close;
end;

function TFrmCadastroProduto.GetIdProduto: Integer;
begin
  Result := FIdProduto;
end;

function TFrmCadastroProduto.GetNome: String;
begin
  Result := FNome;
end;

function TFrmCadastroProduto.GetValorUnitario: Double;
begin
  Result := fValorUnitario;
end;

procedure TFrmCadastroProduto.grdConsultaDblClick(Sender: TObject);
begin
  inherited;

  if (not fPesquisando) then
    Exit;

  Nome          := fmtConsulta.FieldByName('Nome').AsString;
  IdProduto     := fmtConsulta.FieldByName('Id').AsInteger;
  ValorUnitario := fmtConsulta.FieldByName('Preco').AsFloat;
  fPesquisando  := False;
  FraBotaobtnSairClick(nil);
end;

procedure TFrmCadastroProduto.LimparCampos;
begin
  edtID.Clear;
  edtNome.Clear;
  edtPreco.Clear;
  mmoDescricao.Clear;
  chkAtivo.Checked := True;
end;

procedure TFrmCadastroProduto.pmiClonarClick(Sender: TObject);
begin
  inherited;

  CarregarCadastro;
end;

function TFrmCadastroProduto.ValidarCadastro: Boolean;
begin
  inherited;

  if Trim(edtNome.Text).IsEmpty then
    raise Exception.Create('Nome não pode ficar vazio.');

  if Trim(edtPreco.Text).IsEmpty then
    raise Exception.Create('Preço não pode ficar vazio.');
end;

procedure TFrmCadastroProduto.Salvar;
begin
  ValidarCadastro;

  inherited;

  AjustarTela;
end;

procedure TFrmCadastroProduto.SetIdProduto(const Value: Integer);
begin
  fIdProduto := Value;
end;

procedure TFrmCadastroProduto.SetNome(const Value: String);
begin
  fNome := Value;
end;

procedure TFrmCadastroProduto.SetValorUnitario(const Value: Double);
begin
  fValorUnitario := Value;
end;

function TFrmCadastroProduto.VerificaAlteracao: Boolean;
begin
  Result := fmtConsulta.IsEmpty or
            (Trim(edtNome.Text) <> fmtConsulta.FieldByName('Nome').AsString) or
            (edtPreco.Text <> fmtConsulta.FieldByName('Preco').AsFloat.ToString) or
            (chkAtivo.Checked <> fmtConsulta.FieldByName('Ativo').AsBoolean)  or
            (Trim(mmoDescricao.Text) <> fmtConsulta.FieldByName('Descricao').AsString.Trim);
end;

procedure TFrmCadastroProduto.AjustarNomeBotao;
begin
  FraBotao.btnOk.Caption := 'Novo';
  if (pgcGeral.ActivePage = tsCadastro) then
    FraBotao.btnOk.Caption := 'Salvar';
end;

end.
