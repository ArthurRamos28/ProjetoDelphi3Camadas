unit uFrmCadastroBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  JvExDBGrids, JvDBGrid, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Menus, System.JSON,
  System.RTTI,

  fraBotaoDuplo, LibUtil;

type
  TFrmCadastroBase = class(TForm)
    pnlfundo: TPanel;
    pnlSuperior: TPanel;
    pgcGeral: TPageControl;
    tsConsulta: TTabSheet;
    tsCadastro: TTabSheet;
    edtConsulta: TEdit;
    chkCadastroAtivo: TCheckBox;
    lblConsulta: TLabel;
    grdConsulta: TJvDBGrid;
    tmrConsulta: TTimer;
    fmtConsulta: TFDMemTable;
    dsConsulta: TDataSource;
    pmMenu: TPopupMenu;
    pmiAlterar: TMenuItem;
    pmiClonar: TMenuItem;
    pmiExcluir: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure grdConsultaDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdConsultaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pmiExcluirClick(Sender: TObject);
    procedure pmiAlterarClick(Sender: TObject);
    procedure pmiClonarClick(Sender: TObject);
    procedure grdConsultaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FJson: String;
    function GetJson: String;
    procedure CadastrarCamposMemTable;
  public
    fTabela: String;
    fSituacaoCadastro: TSituacaoCadastro;
    fPesquisando: Boolean;

    procedure CarregarCadastro; virtual;
    procedure Consultar; virtual;
    procedure CarregarGrid; virtual;
    procedure Salvar; virtual;
    procedure SincronizarComponentesParaDataSet; virtual;

    property Json: String read GetJson;
  end;

var
  FrmCadastroBase: TFrmCadastroBase;

implementation

{$R *.dfm}

procedure TFrmCadastroBase.CadastrarCamposMemTable;
  function PrimeiraLetraMaiuscula(const Texto: string): string;
  begin
    if Texto = '' then
      Exit('');

    Result := AnsiUpperCase(Texto[1]) + Copy(Texto, 2, Length(Texto));
  end;
begin
  if (not Assigned(FmtConsulta)) then
    Exit;

  if FmtConsulta.Active or (FmtConsulta.FieldCount > 0) then
    Exit;

  for var mI := 0 to Pred(ComponentCount) do
    begin
      var mComponente := Components[mI];
      var mNome       := LowerCase(mComponente.Name);

      if (mNome = 'edtconsulta') or (mNome = 'chkcadastroativo') then
        Continue;

      if (mComponente is TEdit) and mNome.StartsWith('edtid') then
        fmtConsulta.FieldDefs.Add(PrimeiraLetraMaiuscula(Copy(mNome, 4, MaxInt)), ftInteger)
      else if (mComponente is TEdit) and mNome.StartsWith('edt') then
        fmtConsulta.FieldDefs.Add(PrimeiraLetraMaiuscula(Copy(mNome, 4, MaxInt)), ftString, 255)
      else if (mComponente is TComboBox) and mNome.StartsWith('cbb') then
        fmtConsulta.FieldDefs.Add(PrimeiraLetraMaiuscula(Copy(mNome, 4, MaxInt)), ftString, 255)
      else if (mComponente is TCheckBox) and mNome.StartsWith('chk') then
        fmtConsulta.FieldDefs.Add(PrimeiraLetraMaiuscula(Copy(mNome, 4, MaxInt)), ftBoolean)
      else if (mComponente is TMemo) and mNome.StartsWith('mmo') then
        fmtConsulta.FieldDefs.Add(PrimeiraLetraMaiuscula(Copy(mNome, 4, MaxInt)), ftMemo);
    end;

  fmtConsulta.CreateDataSet;
end;

procedure TFrmCadastroBase.CarregarCadastro;
begin
  pgcGeral.ActivePage := tsCadastro;
  if (fmtConsulta.FindField('Id') <> nil) then
    fmtConsulta.Locate('id', fmtConsulta.FieldByName('Id').AsInteger, []);
end;

procedure TFrmCadastroBase.SincronizarComponentesParaDataSet;
begin
  if (not fmtConsulta.Active) then
    begin
      if fmtConsulta.FieldDefs.Count > 0 then
        TFDMemTable(fmtConsulta).CreateDataSet
      else
        Exit;
    end;

  if (fSituacaoCadastro = scaAlterando) then
    fmtConsulta.Edit
  else
    fmtConsulta.Append;

  for var mI := 0 to Pred(fmtConsulta.FieldCount) do
    begin
      var mCampo     := fmtConsulta.Fields[mI];
      var mCampoNome := LowerCase(mCampo.FieldName);

      for var mII := 0 to Pred(ComponentCount) do
        begin
          var mComponente     := Components[mII];
          var mComponenteNome := LowerCase(mComponente.Name);

          if (mComponente is TEdit) then
            begin
              if (mComponenteNome = 'edt' + mCampoNome) then
                begin
                  var mValorTela := TEdit(mComponente).Text;

                  if (mCampo.AsString <> mValorTela) then
                    mCampo.AsString := mValorTela
                  else if (fSituacaoCadastro in [scaInserindo, scaClonando]) and (mCampoNome.ToLower = 'id') then
                    mCampo.AsString := '0';

                  Break;
                end;
            end
          else if (mComponente is TComboBox) then
            begin
              if (mComponenteNome = 'cbb' + mCampoNome) then
                begin
                  var mValorTela := TComboBox(mComponente).Text;

                  if (mCampo.AsString <> mValorTela) then
                    mCampo.AsString := mValorTela;

                  Break;
                end;
            end
          else if (mComponente is TCheckBox) then
            begin
              if (mComponenteNome = 'chk' + mCampoNome) then
                begin
                  var mValorTela := TCheckBox(mComponente).Checked;

                  if (mCampo.AsBoolean <> mValorTela) then
                    mCampo.AsBoolean := mValorTela;

                  Break;
                end;
            end
          else if (mComponente is TMemo) then
            begin
              if (mComponenteNome = 'mmo' + mCampoNome) then
                begin
                  var mValorTela := TMemo(mComponente).Text;

                  if (mCampo.AsString <> mValorTela) then
                    mCampo.AsString := mValorTela;

                  Break;
                end;
            end
        end;
    end;

  fmtConsulta.Post;
end;

procedure TFrmCadastroBase.CarregarGrid;
begin
  CadastrarCamposMemTable;
  var mJsonArray := TJSONObject.ParseJSONValue(Json);
  try
    if (not Assigned(mJsonArray)) then
      Exit;

    if mJsonArray is TJSONObject then
      begin

        fSituacaoCadastro := scaInserindo;
        Exit;
      end;

    TConversorJson.JSONArrayParaObjeto(fmtConsulta, TJSONArray(mJsonArray));
  finally
    mJsonArray.Free;
  end;
end;

procedure TFrmCadastroBase.Consultar;
begin
  var mOutCodigo := 0;
  var mOutTexto  := '';
  TConexaoServer.RESTExecutar(tvhGet, TConexaoServer.GetUrl(fTabela, fSituacaoCadastro), '', 100000, mOutCodigo, mOutTexto, taNenhum);

  if (mOutCodigo < 200) or (mOutCodigo >= 300) then
    raise Exception.Create('Não houve retorno do servidor, verifique a conexão!');

  FJson := mOutTexto;
end;

procedure TFrmCadastroBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(fmtConsulta) and (fmtConsulta.Active) and (not fmtConsulta.IsEmpty) then
    begin
      fmtConsulta.DisableControls;
      try
        fmtConsulta.Cancel;
        fmtConsulta.Close;
        fmtConsulta.FieldDefs.Clear;
        fmtConsulta.Fields.Clear;
      finally
        fmtConsulta.EnableControls;
      end;
    end;
end;

procedure TFrmCadastroBase.FormCreate(Sender: TObject);
begin
  fSituacaoCadastro   := scaInserindo;
  pgcGeral.ActivePage := tsConsulta;
  pgcGeral.Top        := -27;
  pgcGeral.Align      := alNone;

  FormStyle := fsNormal;

  Consultar;
  CarregarGrid;
end;

function TFrmCadastroBase.GetJson: String;
begin
  Result := FJson;
  if (not Result.Trim.IsEmpty) then
    Exit;

  Consultar;
  Result := FJson;
end;

procedure TFrmCadastroBase.grdConsultaDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  if fmtConsulta.IsEmpty or (Column.Title.Caption <> 'Alt.') then
    Exit;

  grdConsulta.Canvas.FillRect(Rect);
  grdConsulta.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, '✏');
end;

procedure TFrmCadastroBase.grdConsultaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (VK_DELETE = Key) then
    pmiExcluirClick(nil);
end;

procedure TFrmCadastroBase.grdConsultaMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Col, Row: Integer;
begin
  if fmtConsulta.IsEmpty then
    Exit;

  TJvDBGrid(Sender).MouseToCell(X, Y, Col, Row);

  if (Col <> 1) then
   Exit;

  fSituacaoCadastro := scaAlterando;
  CarregarCadastro;
end;

procedure TFrmCadastroBase.pmiAlterarClick(Sender: TObject);
begin
  if fmtConsulta.IsEmpty then
    Exit;

  fSituacaoCadastro := scaAlterando;
  CarregarCadastro;
end;

procedure TFrmCadastroBase.pmiClonarClick(Sender: TObject);
begin
   if fmtConsulta.IsEmpty then
    Exit;

  fSituacaoCadastro := scaClonando;
end;

procedure TFrmCadastroBase.pmiExcluirClick(Sender: TObject);
begin
  if fmtConsulta.IsEmpty then
    Exit;

  var mOutCodigo    := 0;
  var mOutTexto     := '';
  fSituacaoCadastro := scaExcluindo;

  var mJson := '{ "Id": ' + fmtConsulta.FieldByName('Id').AsInteger.ToString + '}';
  TConexaoServer.RESTExecutar(tvhDelete, TConexaoServer.GetUrl(fTabela, fSituacaoCadastro), mJson, 100000, mOutCodigo, mOutTexto, taNenhum);

  fmtConsulta.Locate('Id', fmtConsulta.FieldByName('Id').AsInteger);
  if (mOutCodigo >= 200) or (mOutCodigo < 300) then
    fmtConsulta.Delete;

  fmtConsulta.Refresh;

  if (mOutCodigo < 200) or (mOutCodigo >= 300) then
    raise Exception.Create('Não foi possivel gravar as informações, verifique a sua conexão com o servidor.');
end;

procedure TFrmCadastroBase.Salvar;
  function GetMetodo: TTipoVerboHTTP;
  begin
    if (fSituacaoCadastro = scaAlterando) then
      Result := tvhPut
    else
      Result := tvhPost;
  end;

  function TratarRetornoInteiro(mRetorno: String): Integer;
  begin
    var mJsonObj := TJSONObject.ParseJSONValue(mRetorno) as TJSONObject;
    mJsonObj.TryGetValue('Id', Result);
  end;
begin
  SincronizarComponentesParaDataSet;

  var mJsonObject : TJSONObject := nil;
  try
    var mOutCodigo := 0;
    var mOutTexto  := '';
    mJsonObject    := TConversorJson.DataSetParaJSONObject(fmtConsulta, fmtConsulta.FieldByName('Id').AsInteger);
    TConexaoServer.RESTExecutar(GetMetodo, TConexaoServer.GetUrl(fTabela, fSituacaoCadastro), mJsonObject.ToString, 0, mOutCodigo, mOutTexto, taNenhum);

    fmtConsulta.Locate('Id', fmtConsulta.FieldByName('Id').AsInteger);
    if (mOutCodigo >= 300) and (fSituacaoCadastro in [scaInserindo, scaClonando]) then
      fmtConsulta.Delete
    else if (fSituacaoCadastro in [scaInserindo, scaClonando, scaNenhum]) then
      begin
        var mId := TratarRetornoInteiro(mOutTexto);
        fmtConsulta.Edit;
        fmtConsulta.FieldByName('id').AsInteger := mId;
      end;

    fmtConsulta.Refresh;

    if (mOutCodigo < 200) or (mOutCodigo >= 300) then
      raise Exception.Create('Não foi possivel gravar as informações, verifique a sua conexão com o servidor.');
  finally
    mJsonObject.Free;
  end;
end;

end.
