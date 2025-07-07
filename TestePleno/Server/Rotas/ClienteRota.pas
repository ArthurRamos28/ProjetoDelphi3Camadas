unit ClienteRota;

interface
uses
  Datasnap.DSHTTPCommon, System.SysUtils, System.Classes, Datasnap.DSHTTP;

type
  TClienteRota = class
    class procedure Alterar(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
    class procedure BuscarLista(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
    class procedure Inserir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
    class procedure Excluir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
  end;

implementation

uses
  RotaBase, LibConexao, ClienteDAO, ClienteVO, LibUtil;

{ TClienteRota }

class procedure TClienteRota.BuscarLista(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mQuery     := TConexao.Nova.Query;
  var mClienteVO := TClienteVO.Create;
  try
    mQuery.SQL.Add(mClienteVO.GetSQL(trsBuscar));
    var mId := ExtrairParametroDaUrl('v1/Cliente/:id', mRequest.URI, 'id');

    if (mId.Trim <> '') then
      begin
        mQuery.SQL.Add('WHERE (cli_id = :mId)');
        mQuery.ParamByName('mId').AsInteger := StrToIntDef(mId, 0);
      end;

    mQuery.SQL.Add('ORDER BY cli_id');
    mResponse.ResponderObjeto(mClienteVO, mQuery);
  finally
    mClienteVO.Free;
  end;
end;

class procedure TClienteRota.Excluir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mClienteVO := TClienteVO.Create;
  try
    mClienteVO.JSONObjectParaObjeto(mRequest.BodyJSON);
    TClienteDAO.Excluir(mClienteVO);

    mResponse.ResponderStatus('"Id" : ' + mClienteVO.Id.ToString);
  finally
    mClienteVO.Free;
  end;
end;

class procedure TClienteRota.Inserir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mClienteVO := TClienteVO.Create;
  try
    mClienteVO.JSONObjectParaObjeto(mRequest.BodyJSON);
    TClienteDAO.Inserir(mClienteVO);

    mResponse.ResponderStatus('"Id" : ' + mClienteVO.Id.ToString);
  finally
    mClienteVO.Free;
  end;
end;

class procedure TClienteRota.Alterar(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mClienteVO := TClienteVO.Create;
  try
    mClienteVO.JSONObjectParaObjeto(mRequest.BodyJSON);
    TClienteDAO.Alterar(mClienteVO);

    mResponse.ResponderStatus('"Id" : ' + mClienteVO.Id.ToString);
  finally
    mClienteVO.Free;
  end;
end;

initialization
  gRotaBase.Get('v1/Cliente', TClienteRota.BuscarLista);
  gRotaBase.Get('v1/Cliente/:id', TClienteRota.BuscarLista);

  gRotaBase.Post('v1/Cliente', TClienteRota.Inserir);

  gRotaBase.Put('v1/Cliente', TClienteRota.Alterar);

  gRotaBase.Delete('v1/Cliente', TClienteRota.Excluir);

end.
