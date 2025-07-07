unit LancamentoRota;

interface

uses
  Datasnap.DSHTTPCommon, System.SysUtils, System.Classes, Datasnap.DSHTTP, System.JSON;

type
  TLancamentoRota = class
    class procedure BuscarLista(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
    class procedure Inserir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
  end;

implementation

uses
  RotaBase, LibConexao, LancamentoDAO, LancamentoItemDAO, LancamentoVO, LancamentoItemVO, LibUtil;

{ TProdutoRota }

class procedure TLancamentoRota.BuscarLista(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mDataInicio := StrToDate(mRequest.GetParametroTexto('DataInicio'));
  var mDataFinal  := StrToDate(mRequest.GetParametroTexto('DataFinal'));

  var mQuery     := TConexao.Nova.Query;
  try
    mQuery.SQL.Add('SELECT * ');
    mQuery.SQL.Add('FROM lancamento');
    mQuery.SQL.Add('  INNER JOIN lancamento_item ON (lan_id = lai_lan_id)');
    mQuery.SQL.Add('  INNER JOIN produto ON (lai_pro_id = pro_id)');
    mQuery.SQL.Add('WHERE (lan_data BETWEEN :mDataInicio AND :mDataFinal)');

    if (not mQuery.Active) then
      begin
        if (not mQuery.Prepared) then
          mQuery.Prepare;

        mQuery.ParamByName('mDataInicio').AsDate := mDataInicio;
        mQuery.ParamByName('mDataFinal').AsDate  := mDataFinal;

        mQuery.Open;
      end;

    if mQuery.IsEmpty then
      begin
        mResponse.ResponderStatus('"messagem": "Não possui resultado para busca!"', 200);
        Exit;
      end;

    TConversorJson.DataSetParaJSONArray(mQuery);
    mResponse.Responder(TConversorJson.DataSetParaJSONArray(mQuery).ToString, 200);
  except
    on E: Exception do
     var mT := E.Message;

  end;
end;

class procedure TLancamentoRota.Inserir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mParsedJson := TJSONObject.ParseJSONValue(mRequest.BodyJSON);
  try
    if mParsedJson is TJSONArray then
      begin
        var mJsonArray := mParsedJson as TJSONArray;

        for var mItemJson in mJsonArray do
          begin
            var mJsonObj := mItemJson as TJSONObject;

            var mLancamentoVO := TLancamentoVO.Create;
            try
              mLancamentoVO.JSONObjectParaObjeto(mJsonObj.ToJSON);
              TLancamentoDAO.Inserir(mLancamentoVO);

              var mArrayItens := mJsonObj.GetValue('ListaLancamentoItemVO') as TJSONArray;
              if Assigned(mArrayItens) then
                begin
                  for var mItem in mArrayItens do
                    begin
                      var mLancamentoItemVO := TLancamentoItemVO.Create;
                      try
                        mLancamentoItemVO.JSONObjectParaObjeto(mItem.ToJSON);
                        mLancamentoItemVO.IdLancamento := mLancamentoVO.Id;
                        TLancamentoItemDAO.Inserir(mLancamentoItemVO);
                      finally
                        mLancamentoItemVO.Free;
                      end;
                    end;
                end;

              mResponse.ResponderStatus('"Id" : ' + mLancamentoVO.Id.ToString);
            finally
              mLancamentoVO.Free;
            end;
          end;
      end;
  finally
    mParsedJson.Free;
  end;
end;

initialization
  gRotaBase.Get('v1/lancamento', TLancamentoRota.BuscarLista);

  gRotaBase.Post('v1/lancamento', TLancamentoRota.Inserir);

end.
