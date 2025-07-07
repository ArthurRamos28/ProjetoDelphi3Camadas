unit ProdutoRota;

interface

uses
  Datasnap.DSHTTPCommon, System.SysUtils, System.Classes, Datasnap.DSHTTP;

type
  TProdutoRota = class
    class procedure Alterar(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
    class procedure BuscarLista(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
    class procedure Inserir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
    class procedure Excluir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
  end;

implementation

uses
  RotaBase, LibConexao, ProdutoDAO, ProdutoVO, LibUtil;

{ TProdutoRota }

class procedure TProdutoRota.BuscarLista(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mQuery     := TConexao.Nova.Query;
  var mProdutoVO := TProdutoVO.Create;
  try
    mQuery.SQL.Add(mProdutoVO.GetSQL(trsBuscar));
    var mId := ExtrairParametroDaUrl('v1/Produto/:id', mRequest.URI, 'id');

    if (mId.Trim <> '') then
      begin
        mQuery.SQL.Add('WHERE (pro_id = :mId)');
        mQuery.ParamByName('mId').AsInteger := StrToIntDef(mId, 0);
      end;

    mQuery.SQL.Add('ORDER BY pro_id');
    mResponse.ResponderObjeto(mProdutoVO, mQuery);
  finally
    mProdutoVO.Free;
  end;
end;

class procedure TProdutoRota.Excluir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mProdutoVO := TProdutoVO.Create;
  try
    mProdutoVO.JSONObjectParaObjeto(mRequest.BodyJSON);
    TProdutoDAO.Excluir(mProdutoVO);

    mResponse.ResponderStatus('"Id" : ' + mProdutoVO.Id.ToString);
  finally
    mProdutoVO.Free;
  end;
end;

class procedure TProdutoRota.Inserir(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mProdutoVO := TProdutoVO.Create;
  try
    mProdutoVO.JSONObjectParaObjeto(mRequest.BodyJSON);
    TProdutoDAO.Inserir(mProdutoVO);

    mResponse.ResponderStatus('"Id" : ' + mProdutoVO.Id.ToString);
  finally
    mProdutoVO.Free;
  end;
end;

class procedure TProdutoRota.Alterar(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
begin
  var mProdutoVO := TProdutoVO.Create;
  try
    mProdutoVO.JSONObjectParaObjeto(mRequest.BodyJSON);
    TProdutoDAO.Alterar(mProdutoVO);

    mResponse.ResponderStatus('"Id" : ' + mProdutoVO.Id.ToString);
  finally
    mProdutoVO.Free;
  end;
end;

initialization
  gRotaBase.Get('v1/Produto', TProdutoRota.BuscarLista);
  gRotaBase.Get('v1/Produto/:id', TProdutoRota.BuscarLista);

  gRotaBase.Post('v1/Produto', TProdutoRota.Inserir);

  gRotaBase.Put('v1/Produto', TProdutoRota.Alterar);

  gRotaBase.Delete('v1/Produto', TProdutoRota.Excluir);

end.
