unit RotaBase;

interface

uses
  System.Generics.Collections, Datasnap.DSHTTPCommon, System.SysUtils, System.Classes,
  System.JSON, Datasnap.DSHTTP, Datasnap.DSService, FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Param,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Error, FireDAC.UI.Intf, System.RegularExpressions,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  LibUtil, BaseVO;
type
  TRota = reference to procedure(Request: TDSHTTPRequest; Response: TDSHTTPResponse);

  TRotaBase = class
  private
    fListaMetodoDelete: TDictionary<String, TRota>;
    fListaMetodoGet: TDictionary<String, TRota>;
    fListaMetodoPost: TDictionary<String, TRota>;
    fListaMetodoPut: TDictionary<String, TRota>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Get(const mUri: String; mApi: TRota);
    procedure Post(const mUri: String; mApi: TRota);
    procedure Put(const mUri: String; mApi: TRota);
    procedure Delete(const mUri: String; mApi: TRota);
    procedure Execute(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
  end;

  TDSHTTPResponseHelper = class Helper for TDSHTTPResponse
  public
    procedure ResponderStatus(mConteudo: String = ''; mCodigoStatus: Integer = 0);
    procedure Responder(mConteudo: String; mCodigoStatus: Integer);
    procedure ResponderObjeto(mBaseVO: TBaseVO; mQuery: TFDQuery; mCodigoStatus: Integer = 0);
  end;

  TDSHTTPRequestHelper = class Helper for TDSHTTPRequest
  private
    function GetParametro(mNomeParametro: String): String;
  public
    function GetParametroTexto(mNomeParametro: String): String;
    function GetParametroInteiro(mNomeParametro: String): Integer;
    function HeaderGet(mNome: String): String;
    function BodyJSON: String;
  end;

var
  gRotaBase: TRotaBase;

implementation

uses
  ConexaoServer;

{ TRotaBase }

constructor TRotaBase.Create;
begin
  fListaMetodoDelete := TDictionary<String, TRota>.Create;
  fListaMetodoGet    := TDictionary<String, TRota>.Create;
  fListaMetodoPost   := TDictionary<String, TRota>.Create;
  fListaMetodoPut    := TDictionary<String, TRota>.Create;
end;

procedure TRotaBase.Delete(const mUri: String; mApi: TRota);
begin
  fListaMetodoDelete.Add(cgUrlBase + mUri.ToLower, mApi);
end;

destructor TRotaBase.Destroy;
begin
  FreeAndNil(fListaMetodoDelete);
  FreeAndNil(fListaMetodoPost);
  FreeAndNil(fListaMetodoPut);
  FreeAndNil(fListaMetodoGet);

  inherited;
end;
procedure TRotaBase.Get(const mUri: string; mApi: TRota);
begin
  fListaMetodoGet.Add(cgUrlBase + mUri.ToLower, mApi);
end;

procedure TRotaBase.Post(const mUri: String; mApi: TRota);
begin
  fListaMetodoPost.Add(cgUrlBase + mUri.ToLower, mApi);
end;

procedure TRotaBase.Put(const mUri: String; mApi: TRota);
begin
  fListaMetodoPut.Add(cgUrlBase + mUri.ToLower, mApi);
end;

procedure TRotaBase.Execute(mRequest: TDSHTTPRequest; mResponse: TDSHTTPResponse);
  function CompararRota(const mRota, mChave: string): Boolean;
  begin
    var mRegex := TRegEx.Replace(mChave, ':[a-zA-Z0-9_]+', '[^/]+');
    Result     := TRegEx.IsMatch(mRota, '^' + mRegex + '$', [roIgnoreCase]);
  end;

  function GetMetodo(mTipoVerboHTTP: TDSHTTPCommandType; mRota: String): TRota;
  begin
    Result := nil;

    var mLista: TDictionary<String, TRota> := nil;
    case mTipoVerboHTTP of
      hcGET    : mLista := fListaMetodoGet;
      hcPOST   : mLista := fListaMetodoPost;
      hcDELETE : mLista := fListaMetodoDelete;
      hcPUT    : mLista := fListaMetodoPut;
    end;

    if (not Assigned(mLista)) then
      Exit;

    if (CopyUltimaLetra(mRota) = '/') then
      mRota := Copy(mRota, 1, (mRota.Length - 1));

    for var mChave in mLista.Keys do
      begin
        if CompararRota(mRota.ToLower, mChave.ToLower) then
          begin
            Result := mLista[mChave];
            Exit;
          end;
      end;
  end;

begin
  var mMetodo : TRota := nil;
  mMetodo := GetMetodo(mRequest.CommandType, mRequest.URI);
  try
    if Assigned(mMetodo) then
      mMetodo(mRequest, mResponse)
    else
      mResponse.ResponderStatus('"mensagem": "Rota não localizada"', 405);
  except
    On E: Exception do
      mResponse.ResponderStatus('"mensagem": ' + E.Message, 500);
  end;
end;

{ TDSHTTPResponseHelper }
procedure TDSHTTPResponseHelper.ResponderObjeto(mBaseVO: TBaseVO; mQuery: TFDQuery; mCodigoStatus: Integer = 0);
begin
  try
    if (not mQuery.Active) then
      begin
        if (not mQuery.Prepared) then
          mQuery.Prepare;

        mQuery.Open;
      end;

    if mQuery.IsEmpty then
      begin
        ResponderStatus('"messagem": "Não possui resultado para busca!"', 200);
        Exit;
      end;

    mQuery.First;
    var mJsonArray := TJSONArray.Create;
    try
      if (mQuery.RecordCount > 1) then
        begin
          while (not mQuery.Eof) do
            begin
              mBaseVO.SetarPropriedade(mQuery);
              mJsonArray.AddElement(mBaseVO.ObjetoParaJSONObject);
              mQuery.Next;
            end;
        end
      else
        begin
          mBaseVO.SetarPropriedade(mQuery);
          mJsonArray := mBaseVO.ObjetoParaJSONArray;
        end;

      if (mCodigoStatus = 0) then
        mCodigoStatus := cgStatusOk;

      ResponseNo := mCodigoStatus;

      if ContentType.Trim.IsEmpty or (ContentType.Trim = 'application/json') then
        ContentType := 'application/json; charset=utf-8';

      ContentText := mJsonArray.ToJson;
    finally
      mJsonArray.Free;
    end;

  except
    On E: Exception do
      ResponderStatus('"mensagem": ' + E.Message, 500);
  end;
end;

procedure TDSHTTPResponseHelper.ResponderStatus(mConteudo: String; mCodigoStatus: Integer);
begin
  if (mCodigoStatus = 0) then
    mCodigoStatus := cgStatusOk;

  ResponseNo := mCodigoStatus;

  if ContentType.Trim.IsEmpty or (ContentType.Trim = 'application/json') then
    ContentType := 'application/json; charset=utf-8';

  ContentText := '{ ' + cgEnter + ' ' + mConteudo + cgEnter + ' }';
end;

procedure TDSHTTPResponseHelper.Responder(mConteudo: String; mCodigoStatus: Integer);
begin
  if (mCodigoStatus = 0) then
    mCodigoStatus := cgStatusOk;

  ResponseNo := mCodigoStatus;

  if ContentType.Trim.IsEmpty or (ContentType.Trim = 'application/json') then
    ContentType := 'application/json; charset=utf-8';

  ContentText := mConteudo;
end;

{ TDSHTTPRequestHelper }

function TDSHTTPRequestHelper.BodyJSON: String;
begin
  Result := '';

  if (not Assigned(TDSHTTPApplication.Instance)) or
     (not Assigned(TDSHTTPApplication.Instance.HTTPDispatch)) or
     (not Assigned(TDSHTTPApplication.Instance.HTTPDispatch.Request)) then
    Exit;

  var mStream := TDSHTTPRequestIndy(TDSHTTPApplication.Instance.HTTPDispatch.Request).RequestInfo.PostStream;

  if Assigned(mStream) and (mStream.Size > 0) then
    Result := StreamParaString(mStream, TEncoding.UTF8);
end;

function TDSHTTPRequestHelper.GetParametro(mNomeParametro: String): String;
begin
  Result := '';

  for var mParametroValor in Self.Params do
    begin
      var mParametro := CopyPos(mParametroValor, '=');
      if (mParametro.ToLower = mNomeParametro.ToLower) then
        begin
          Result := CopyAposPosPalavra(mParametroValor, '=');
          Exit;
        end;
    end;
end;

function TDSHTTPRequestHelper.HeaderGet(mNome: String): String;
begin
  Result := TDSHTTPRequestIndy(Self).RequestInfo.RawHeaders.Values[mNome];
end;

function TDSHTTPRequestHelper.GetParametroInteiro(mNomeParametro: String): Integer;
begin
  Result := StrToInt64Def(GetParametro(mNomeParametro), 0);
end;

function TDSHTTPRequestHelper.GetParametroTexto(mNomeParametro: String): String;
begin
  Result := GetParametro(mNomeParametro);
end;

initialization
  gRotaBase := TRotaBase.Create;

finalization
  FreeAndNil(gRotaBase);

end.
