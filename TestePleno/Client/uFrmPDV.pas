unit uFrmPDV;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.Math, System.DateUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, System.JSON,
  uDMImagem, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  LibUtil;

type
  TFrmPDV = class(TForm)
    grdLancamento: TDBGrid;
    pnl1: TPanel;
    pnl2: TPanel;
    edtCliente: TEdit;
    btnPesquisar: TButton;
    lbl1: TLabel;
    edtIdProduto: TButtonedEdit;
    lblNomeProduto: TLabel;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    edtValorTotal: TEdit;
    pnl3: TPanel;
    lblTotalLancado: TLabel;
    btnFechar: TButton;
    btnIncluir: TButton;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lblNomeTotal: TLabel;
    fmtLancamento: TFDMemTable;
    dsLancamentoItem: TDataSource;
    fmtLancamentoValorTotal: TFloatField;
    fmtLancamentoDataCadastro: TDateField;
    fmtLancamentoItem: TFDMemTable;
    fmtLancamentoItemId: TIntegerField;
    fmtLancamentoItemIdLancamento: TIntegerField;
    fmtLancamentoItemIdProduto: TIntegerField;
    fmtLancamentoItemQuantidade: TIntegerField;
    fmtLancamentoItemValorUnitario: TFloatField;
    fmtLancamentoItemValorTotal: TFloatField;
    fmtLancamentoItemNomeProduto: TStringField;
    fmtLancamentoId: TIntegerField;
    fmtLancamentoIdCliente: TIntegerField;
    fmtLancamentoNomeCliente: TStringField;
    procedure btnFecharClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure edtIdProdutoClick(Sender: TObject);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure edtIdProdutoChange(Sender: TObject);
  private
    fIdCliente, fIdProduto: Integer;
    procedure CalculaSoma;
    function TotalLancamento: Double;
    procedure FecharGravar;
  public
    { Public declarations }
  end;

var
  FrmPDV: TFrmPDV;

implementation

uses
  uFrmCadastroCliente, uFrmCadastroProduto, LancamentoVO;

{$R *.dfm}

procedure TFrmPDV.btnFecharClick(Sender: TObject);
begin
  if (not fmtLancamento.Active) then
    fmtLancamento.Open;

  fmtLancamento.Append;

  fmtLancamentoNomeCliente.AsString      := edtCliente.Text;
  fmtLancamentoValorTotal.AsFloat        := TotalLancamento;
  fmtLancamentoDataCadastro.AsDateTime   := DateOf(Now);

  if (fIdCliente > 0) then
    fmtLancamentoIdCliente.AsInteger := fIdCliente;

    fmtLancamento.Post;

  FecharGravar;
 end;

procedure TFrmPDV.FecharGravar;
begin
  var mOutCodigo    := 0;
  var mOutTexto     := '';
  var mLancamentoVO := TLancamentoVO.Create;
  var mJsonArray    := TJSONArray.Create;
  try
    FmtLancamento.First;
    if (FmtLancamento.RecordCount > 1) then
      begin
        while (not FmtLancamento.Eof) do
          begin
            mLancamentoVO.SetarPropriedade(FmtLancamento, fmtLancamentoItem);
            mJsonArray.AddElement(mLancamentoVO.ObjetoParaJSONObject);
            FmtLancamento.Next;
          end;
      end
    else
      begin
        mLancamentoVO.SetarPropriedade(FmtLancamento, fmtLancamentoItem);
        mJsonArray := mLancamentoVO.ObjetoParaJSONArray;
      end;

    TConexaoServer.RESTExecutar(tvhPost, TConexaoServer.GetUrl('lancamento', scaInserindo), mJsonArray.ToString, 0, mOutCodigo, mOutTexto, taNenhum);

    if (mOutCodigo < 200) or (mOutCodigo >= 300) then
      raise Exception.Create('Não foi possivel gravar as informações, verifique a sua conexão com o servidor.');

    fmtLancamento.EmptyDataSet;
    fmtLancamentoItem.EmptyDataSet;
    edtCliente.Clear;
    edtIdProduto.Clear;
    edtValorTotal.Clear;
    edtValorUnitario.Clear;
    edtQuantidade.Clear;
    lblNomeProduto.Caption := 'Nome do produto';
    lblTotalLancado.Caption := 'R$ 0,00';
  finally
    mLancamentoVO.Free;
  end;
end;

procedure TFrmPDV.btnIncluirClick(Sender: TObject);
begin
  if (not fmtLancamentoItem.Active) then
    fmtLancamentoItem.Open;

  fmtLancamentoItem.Append;

  fmtLancamentoItemNomeProduto.AsString  := lblNomeProduto.Caption;
  fmtLancamentoItemQuantidade.AsInteger  := StrToInt(edtQuantidade.Text);
  fmtLancamentoItemValorUnitario.AsFloat := StrToFloat(edtValorUnitario.Text);
  fmtLancamentoItemValorTotal.ASFloat    := StrToFloat(edtValorTotal.Text);

  if (fIdProduto > 0) then
    fmtLancamentoItemIdProduto.AsInteger := fIdProduto;

  fmtLancamentoItem.Post;
  lblTotalLancado.Caption := 'R$ ' + FormatFloat('#,##0.00', TotalLancamento);
end;

function TFrmPDV.TotalLancamento: Double;
begin
  fmtLancamentoItem.First;
  while (not fmtLancamentoItem.Eof) do
    begin
      Result := Result + fmtLancamentoItemValorTotal.AsFloat;
      fmtLancamentoItem.Next;
    end;
end;

procedure TFrmPDV.btnPesquisarClick(Sender: TObject);
begin
  var mFrmCadastroCliente := TFrmCadastroCliente.Create(Self);
  try

    mFrmCadastroCliente.fPesquisando := True;
    mFrmCadastroCliente.ShowModal;

    edtCliente.Text := mFrmCadastroCliente.Nome;
    fIdCliente      := mFrmCadastroCliente.IdCliente;
  finally
    mFrmCadastroCliente.Free;
  end;
end;

procedure TFrmPDV.edtIdProdutoChange(Sender: TObject);
begin
  if Trim(edtValorTotal.Text).IsEmpty then
    Exit;

  edtValorTotal.Clear;
  edtValorUnitario.Clear;
  edtQuantidade.Clear;
end;

procedure TFrmPDV.edtIdProdutoClick(Sender: TObject);
begin
  var mFrmCadastroProduto := TFrmCadastroProduto.Create(Self);
  try
    mFrmCadastroProduto.fPesquisando := True;
    mFrmCadastroProduto.ShowModal;

    lblNomeProduto.Caption := mFrmCadastroProduto.Nome;
    fIdProduto             := mFrmCadastroProduto.IdProduto;
    edtIdProduto.Text      := fIdProduto.ToString;
    edtValorUnitario.Text  := mFrmCadastroProduto.ValorUnitario.ToString;
  finally
    mFrmCadastroProduto.Free;
  end;
end;

procedure TFrmPDV.edtQuantidadeChange(Sender: TObject);
begin
  CalculaSoma;
end;

procedure TFrmPDV.CalculaSoma;
begin
  var mValorUnitario: Double;
  if (not TryStrToFloat(edtValorUnitario.Text, mValorUnitario)) then
    mValorUnitario := 0.00;

  var mQuantidade: Double;
  if (not TryStrToFloat(edtQuantidade.Text, mQuantidade)) then
    mQuantidade := 1;

  var mSoma := (mQuantidade * mValorUnitario);

  edtValorTotal.Text := mSoma.ToString;
end;

end.
