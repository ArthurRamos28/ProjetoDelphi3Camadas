unit uFrmRelatorioVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.JSON,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, frxClass, frxDBSet,
  LibUtil, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON;

type
  TFrmRelatorioVenda = class(TForm)
    frxDBDataSet: TfrxDBDataset;
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    edtDataInicio: TDateTimePicker;
    edtDataFinal: TDateTimePicker;
    btnGerar: TButton;
    fmtRelatorio: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    frxReport: TfrxReport;
    procedure btnGerarClick(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRelatorioVenda: TFrmRelatorioVenda;

implementation

{$R *.dfm}

procedure TFrmRelatorioVenda.btnGerarClick(Sender: TObject);
begin
  if fmtRelatorio.Active then
    fmtRelatorio.EmptyDataSet;

  var mOutCodigo := 0;
  var mOutTexto  := '';
  var mUrl := TConexaoServer.GetUrl('lancamento', scaNenhum);
  mUrl := mUrl + '?DataInicio=' + DateToStr(edtDataInicio.Date) + '&DataFinal=' + DateToStr(edtDataFinal.Date);
  TConexaoServer.RESTExecutar(tvhGet, mUrl, '', 100000, mOutCodigo, mOutTexto, taNenhum);

  if (mOutCodigo < 200) or (mOutCodigo >= 300) then
    raise Exception.Create('Não foi possivel gravar as informações, verifique a sua conexão com o servidor.');

  var mJsonArray := TJSONObject.ParseJSONValue(mOutTexto) as TJSONArray;
  TConversorJson.JSONArrayParaObjeto(fmtRelatorio, mJsonArray);

  frxDBDataSet.DataSet := fmtRelatorio;
  frxReport.ShowReport;
end;


end.
