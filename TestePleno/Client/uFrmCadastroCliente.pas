unit uFrmCadastroCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, ACBrCEP,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmCadastroBase, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.StdCtrls, Vcl.Menus,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, JvExDBGrids, JvDBGrid, Vcl.ComCtrls,
  LibUtil, fraBotaoDuplo;

type
  TFrmCadastroCliente = class(TFrmCadastroBase)
    edtID: TEdit;
    edtNome: TEdit;
    edtCpf: TEdit;
    edtCep: TEdit;
    edtEndereco: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    cbbEstado: TComboBox;
    chkAtivo: TCheckBox;
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    FraBotao: TufraBotaoDuplo;
    procedure FormCreate(Sender: TObject);
    procedure FraBotaobtnOkClick(Sender: TObject);
    procedure FraBotaobtnSairClick(Sender: TObject);
    procedure pmiClonarClick(Sender: TObject);
    procedure edtCepExit(Sender: TObject);
    procedure grdConsultaDblClick(Sender: TObject);
  private
    FNome: String;
    FIdCliente: Integer;
    procedure LimparCampos;
    procedure CarregarGrid; override;
    procedure CarregarCadastro; override;
    procedure AjustarNomeBotao;
    function VerificaAlteracao: Boolean;
    procedure Salvar; override;
    procedure AjustarTela(mConsulta: Boolean = True);
    function ValidarCadastro: Boolean;
    function GetNome: String;
    procedure SetNome(const Value: String);
    function GetIdCliente: Integer;
    procedure SetIdCliente(const Value: Integer);
  public
    function Abrir: Boolean;

    property Nome: String read GetNome write SetNome;
    property IdCliente: Integer read GetIdCliente write SetIdCliente;
  end;

var
  FrmCadastroCliente: TFrmCadastroCliente;

implementation

{$R *.dfm}

procedure TFrmCadastroCliente.CarregarCadastro;
begin
  inherited;

  if (fSituacaoCadastro in [scaAlterando, scaClonando]) then
    begin
      if (fSituacaoCadastro = scaAlterando) then
       edtID.Text := fmtConsulta.FieldByName('Id').AsInteger.ToString;

      edtNome.Text        := fmtConsulta.FieldByName('Nome').AsString;
      edtCpf.Text         := fmtConsulta.FieldByName('Cpf').AsString;
      edtCep.Text         := fmtConsulta.FieldByName('Cep').AsString;
      edtEndereco.Text    := fmtConsulta.FieldByName('Endereco').AsString;
      edtBairro.Text      := fmtConsulta.FieldByName('Bairro').AsString;
      edtCidade.Text      := fmtConsulta.FieldByName('Cidade').AsString;
      cbbEstado.ItemIndex := cbbEstado.Items.IndexOf(fmtConsulta.FieldByName('Estado').AsString);
      chkAtivo.Checked    := fmtConsulta.FieldByName('Ativo').AsBoolean;
    end
  else
    LimparCampos;

  AjustarNomeBotao;
end;

procedure TFrmCadastroCliente.CarregarGrid;
begin
  inherited;

  grdConsulta.Columns[1].FieldName := 'Id';
  grdConsulta.Columns[2].FieldName := 'Nome';
end;

procedure TFrmCadastroCliente.edtCepExit(Sender: TObject);
begin
  inherited;

  if (not Trim(edtCep.Text).IsEmpty) then
    begin
      var mACBrCEP := TACBrCep.Create(nil);
      try
        mACBrCEP.WebService  := wsCepAberto;
        mACBrCEP.ChaveAcesso := 'a839b1b50061a3dd78f89f5399ce29b4';
        mACBrCEP.BuscarPorCEP(Trim(edtCep.Text));

        if (mACBrCEP.Enderecos.Count < 1) then
          Exit
        else
          begin
            for var mI := 0 to Pred(mACBrCEP.Enderecos.Count) do
              begin
                if Trim(edtEndereco.Text).IsEmpty then
                  edtEndereco.Text := Trim(mACBrCEP.Enderecos[mI].Tipo_Logradouro + ' ' + mACBrCEP.Enderecos[mI].Logradouro);

                if Trim(edtBairro.Text).IsEmpty then
                  edtBairro.Text := mACBrCEP.Enderecos[mI].Bairro;

                if Trim(edtCidade.Text).IsEmpty then
                  edtCidade.Text := mACBrCEP.Enderecos[mI].Municipio;

                cbbEstado.ItemIndex := cbbEstado.Items.IndexOf(mACBrCEP.Enderecos[mI].UF);
              end;
          end;
      finally
        mACBrCEP.Free;
      end;

    end;
end;

procedure TFrmCadastroCliente.FormCreate(Sender: TObject);
begin
  fTabela := 'Cliente';

  inherited;

  AjustarNomeBotao;
end;

procedure TFrmCadastroCliente.AjustarTela(mConsulta: Boolean = True);
begin
  if mConsulta then
    begin
      pgcGeral.ActivePage := tsConsulta;
      fSituacaoCadastro   := scaInserindo;
      LimparCampos;
    end
  else
    pgcGeral.ActivePage := tsCadastro;

  AjustarNomeBotao;
end;

procedure TFrmCadastroCliente.FraBotaobtnOkClick(Sender: TObject);
begin
  inherited;

  if (pgcGeral.ActivePage = tsConsulta) then
    AjustarTela(False)
  else if (pgcGeral.ActivePage = tsCadastro) and (VerificaAlteracao or (fSituacaoCadastro = scaClonando)) then
    Salvar
  else
    FraBotaobtnSairClick(nil);
end;

procedure TFrmCadastroCliente.FraBotaobtnSairClick(Sender: TObject);
begin
  inherited;

  if (pgcGeral.ActivePage = tsCadastro) then
    AjustarTela
  else
    Close;
end;

function TFrmCadastroCliente.GetIdCliente: Integer;
begin
  Result := FIdCliente;
end;

function TFrmCadastroCliente.GetNome: String;
begin
  Result := FNome;
end;

procedure TFrmCadastroCliente.grdConsultaDblClick(Sender: TObject);
begin
  inherited;

  if (not fPesquisando) then
    Exit;

  Nome         := fmtConsulta.FieldByName('Nome').AsString;
  IdCliente    := fmtConsulta.FieldByName('Id').AsInteger;
  fPesquisando := False;
  FraBotaobtnSairClick(nil);
end;

procedure TFrmCadastroCliente.LimparCampos;
begin
  edtID.Clear;
  edtNome.Clear;
  edtCpf.Clear;
  edtCep.Clear;
  edtEndereco.Clear;
  edtBairro.Clear;
  edtCidade.Clear;
  cbbEstado.ItemIndex := 0;
  chkAtivo.Checked    := True;
end;

procedure TFrmCadastroCliente.pmiClonarClick(Sender: TObject);
begin
  inherited;

  CarregarCadastro;
end;

function TFrmCadastroCliente.ValidarCadastro: Boolean;
begin
  inherited;

  if Trim(edtNome.Text).IsEmpty then
    raise Exception.Create('Nome não pode ficar vazio.');
end;

procedure TFrmCadastroCliente.Salvar;
begin
  ValidarCadastro;

  inherited;

  AjustarTela;
end;

procedure TFrmCadastroCliente.SetIdCliente(const Value: Integer);
begin
  FIdCliente := Value;
end;

procedure TFrmCadastroCliente.SetNome(const Value: String);
begin
  FNome := Value;
end;

function TFrmCadastroCliente.VerificaAlteracao: Boolean;
begin
  Result := fmtConsulta.IsEmpty or
            (Trim(edtNome.Text) <> fmtConsulta.FieldByName('Nome').AsString) or
            (edtCpf.Text <> fmtConsulta.FieldByName('Cpf').AsString) or
            (chkAtivo.Checked <> fmtConsulta.FieldByName('Ativo').AsBoolean) or
            (Trim(edtCep.Text) <> fmtConsulta.FieldByName('Cep').AsString.Trim) or
            (Trim(edtEndereco.Text) <> fmtConsulta.FieldByName('Endereco').AsString.Trim) or
            (Trim(edtBairro.Text) <> fmtConsulta.FieldByName('Bairro').AsString.Trim) or
            (Trim(edtCidade.Text) <> fmtConsulta.FieldByName('Cidade').AsString.Trim) or
            (cbbEstado.Text  <> fmtConsulta.FieldByName('Estado').AsString);
end;

function TFrmCadastroCliente.Abrir: Boolean;
begin
  //Application.CreateForm(TFrmCadastroCliente, FrmCadastroCliente);
  FrmCadastroCliente.Show;
  FrmCadastroCliente.BringToFront;
end;

procedure TFrmCadastroCliente.AjustarNomeBotao;
begin
  FraBotao.btnOk.Caption := 'Novo';
  if (pgcGeral.ActivePage = tsCadastro) then
    FraBotao.btnOk.Caption := 'Salvar';
end;



end.
