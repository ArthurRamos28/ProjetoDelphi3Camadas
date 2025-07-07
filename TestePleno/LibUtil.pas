unit LibUtil;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, System.Math, System.NetEncoding, ACBrSocket, ACBrUtil.Strings,
  Data.DBXJSON, System.JSON, System.RTTI, System.TypInfo, System.Generics.Collections, System.Types, Data.DB, Web.HTTPApp, Datasnap.DSServer,
  FireDAC.Comp.Client, Vcl.Forms, System.IniFiles, Winapi.Windows, Winapi.Messages, ShellAPI, System.DateUtils;

const
  cgEnter = #13#10;
  cgSenhaBanco = 'masterkey';
  cgUsuarioBanco = 'SYSDBA';
  cgProtocoloBanco = 'TCP/IP';
  cgIpBanco = 'localhost';
  cgPortaBanco = '3050';
  cgUrlBase = '/datasnap/rest/';
  cgStatusOk = 200;
  cgStatusNotFound = 404;
  cgVersaoServer = 'v1/';

type
  TTipoCampo = (tcString, tcInteger, tcFloat, tcBoolean, tcDate, tcDateTime);
  TTipoResultSQL = (trsInserir, trsAlterar, trsExcluir, trsBuscar, trsInserirAlterar);
  TSituacaoCadastro = (scaNenhum, scaInserindo, scaAlterando, scaExcluindo, scaClonando);
  TTipoVerboHTTP = (tvhGet, tvhPost, tvhPut, tvhDelete);
  TTipoAutenticacao = (taNenhum, taBasic, taBearerToken, taDigestAuth);

  TConversorJson = class
    class function DataSetParaJSONArray(mDataSet: TDataSet; mId: Integer = -1): TJSONArray;
    class procedure JSONObjectParaObjeto(mObjeto: TObject; mJson: String);
    class function ObjetoParaJSONArray(mObjeto: TObject): TJSONArray;
    class function ObjetoParaJSONObject(mObjeto: TObject): TJSONObject;
    class procedure JSONArrayParaObjeto(mFmt: TDataSet; mJsonArray: TJSONArray);
    class function DataSetParaJSONObject(mDataSet: TDataSet; mId: Integer = -1): TJSONObject;
  end;

  TConexaoServer = class
    class function GetUrl(mTabela: String; mSituacaoCadastro: TSituacaoCadastro; mId: String = ''): String;
    class function RESTExecutar(mVerbo: TTipoVerboHTTP; mURLCompleta, mBody: String; mTimeOut: Integer;
      out mOutRespostaCodigoStatus: Integer; out mOutRespostaTexto: String; mTipoAutenticacao: TTipoAutenticacao;
      mHeader: String = ''): Boolean;
  end;

  function CopyAposPosPalavra(mString, mStringPos: String; mRetiraEspaco: Boolean = True): String;
  function CopyPos(mString, mStringPos: String; mRetiraEspaco: Boolean = True): String;
  function CopyUltimaPalavraPos(mString, mStringPos: String; mRetiraEspaco: Boolean = True): String;
  function CopyUltimaLetra(mString: String): String;
  function JuntarString(mString, mStringJuntar, mStringSeparador: String): String;
  function StreamParaString(mStream: TStream; mEncoding: TEncoding): String;
  function ExtrairParametroDaUrl(const mUriPadrao, mUriAtual, mParametro: String): String;
  function GetDiretorioExe: String;
  function ArquivoConexao: Boolean;
  procedure CriarArquivoServer;
  function DecodificarJSON(mJSON: String): String;

var
  gCaminhoBanco, gIp: String;
  gPortaHttp: Integer;


implementation

function CopyAposPosPalavra(mString, mStringPos: String; mRetiraEspaco: Boolean = True): String;
begin
  var mPos := (Pos(mStringPos, mString) + Length(mStringPos));

  if mRetiraEspaco then
    Result := Trim(Copy(mString, mPos, MaxInt))
  else
    Result := Copy(mString, mPos, MaxInt);
end;

procedure CriarArquivoServer;
  procedure CriarArquivoPeloCMD(mCaminhoDoArquivo: String);
  begin
    var mCmdLine := 'cmd.exe /c echo. > ' + mCaminhoDoArquivo;

    if (ShellExecute(0, 'runas', 'cmd.exe', PChar(mCmdLine), nil, SW_HIDE) <= 32) then
      raise Exception.Create('Erro ao executar o CMD como administrador.');

    Sleep(1000);
  end;

begin
  try
    var mCaminhoArquivo := GetDiretorioExe + 'Server.ini';
    CriarArquivoPeloCMD(mCaminhoArquivo);
    var mConfigINI := TStringList.Create;
    try
      mConfigINI.Add('[Server]');
      mConfigINI.Add('IP=' + cgIpBanco);
      mConfigINI.Add('Porta=' + 8080.ToString);

      mConfigINI.SaveToFile(mCaminhoArquivo);
    finally
      mConfigINI.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao salvar o arquivo.');
  end;
end;

function GetDiretorioExe: String;
begin
  {$IFDEF linux}
  Result := System.SysUtils.GetCurrentDir;
  {$ELSE}
  Result := ExtractFilePath(Application.ExeName);
  {$ENDIF}
  if (RightStr(Result, 1) <> '\') then
    Result := Result + '\';
end;

function ArquivoConexao: Boolean;
begin
  Result := False;
  var mCaminhoArquivo := GetDiretorioExe + 'Server.ini';

  if (not FileExists(mCaminhoArquivo)) then
    Exit;

  var mArquivoServer := TIniFile.Create(mCaminhoArquivo);
  try
    gPortaHttp := mArquivoServer.ReadInteger('Server', 'Porta', 8080);
    gIp        := mArquivoServer.ReadString('Server', 'Ip', cgIpBanco);

    Result := (gPortaHttp <> 0) and (not gIp.Trim.IsEmpty);
  finally
    mArquivoServer.Free;
  end;
end;

function CopyPos(mString, mStringPos: String; mRetiraEspaco: Boolean = True): String;
begin
  Result := LeftStr(mString, Pred((Pos(mStringPos, mString))));

  if mRetiraEspaco then
    Result := Trim(Result);
end;

function CopyUltimaPalavraPos(mString, mStringPos: String; mRetiraEspaco: Boolean = True): String;
begin
  for var mI := Length(mString) downto 1 do
    begin
      if (mString[mI] = mStringPos) then
        begin
          Result := Copy(mString, (mI + 1), (mString.Length - mI));
          Break;
        end;
    end;

  if mRetiraEspaco then
    Result := Result.Trim;
end;

function CopyUltimaLetra(mString: String): String;
begin
  Result := Copy(mString, mString.Length, 1);
end;

function JuntarString(mString, mStringJuntar, mStringSeparador: String): String;
begin
  Result := mString;

  if (Trim(Result) <> '') and
     (Trim(mStringJuntar) <> '') and
     ((mStringSeparador <> '') or (mStringSeparador = cgEnter)) then
    Result := Result + mStringSeparador;

  Result := Result + mStringJuntar;
end;

function StreamParaString(mStream: TStream; mEncoding: TEncoding): String;
begin
 Result := '';
  if (not Assigned(mStream)) or (mStream.Size = 0) then
    Exit;
  try
    var Bytes: TBytes;
    SetLength(Bytes, mStream.Size);
    mStream.Position := 0;
    mStream.ReadBuffer(Bytes[0], Length(Bytes));
    var StartIndex: Integer := 0;
    if (Length(Bytes) >= 3) and (Bytes[0] = $EF) and (Bytes[1] = $BB) and (Bytes[2] = $BF) then
      StartIndex := 3;
    Result := TEncoding.UTF8.GetString(Copy(Bytes, StartIndex, Length(Bytes) - StartIndex));
  except
    on E: Exception do
     var mT := E.Message;
  end;
end;

function ExtrairEndPointUrl(const mUrl: String): String;
begin
  var mPosPrefixo := Pos(cgUrlBase.ToLower, mUrl.ToLower);
  if (mPosPrefixo > 0) then
    Result := Copy(mUrl, (mPosPrefixo + Length(cgUrlBase)), MaxInt)
  else
    Result := mUrl;
end;

function DecodificarJSON(mJSON: String): String;
begin
  var mJSONObjeto : TJSONValue := nil;
  try
    try
      mJSONObjeto := TJSONObject.ParseJSONValue(mJSON);
      Result := TJSONObject(mJSONObjeto).ToString;
      Result := StringReplace(Result, '\/', '/', [rfReplaceAll]);
    except
      Result := mJSON;
    end;
  finally
    FreeAndNil(mJSONObjeto);
  end;
end;

function ExtrairParametroDaUrl(const mUriPadrao, mUriAtual, mParametro: String): String;
begin
  Result := '';
  var mPartesPadrao := mUriPadrao.ToLower.Split(['/']);
  var mPartesAtual  := ExtrairEndPointUrl(mUriAtual).ToLower.Split(['/']);

  if (Length(mPartesPadrao) <> Length(mPartesAtual)) then
    Exit;

  for var mI := 0 to High(mPartesPadrao) do
    begin
      if (mPartesPadrao[mI].StartsWith(':') and (mPartesPadrao[mI].Substring(1) = mParametro)) then
        begin
          Result := mPartesAtual[mI];
          Exit;
        end;
    end;
end;

{ TConversorJson }
class function TConversorJson.ObjetoParaJSONArray(mObjeto: TObject): TJSONArray;
begin
  Result := nil;
  if (not Assigned(mObjeto)) then
    Exit;

  var mJsonArray := TJSONArray.Create;
  mJsonArray.AddElement(ObjetoParaJSONObject(mObjeto));
  Result := mJsonArray;
end;

class function TConversorJson.DataSetParaJSONArray(mDataSet: TDataSet; mId: Integer = -1): TJSONArray;
begin
  Result := TJSONArray.Create;
  if (not Assigned(mDataSet)) or (mDataSet.IsEmpty) then
    Exit;

  var mJSONObjeto : TJSONObject := nil;
  var mCampoTag   := '';
  mDataSet.DisableControls;
  try
    mDataSet.First;
    if (mId >= 0) and (mDataSet.FindField('id') <> nil) then
      mDataSet.Locate('id', mId, []);

    while (not mDataSet.Eof) do
      begin
        mJSONObjeto := TJSONObject.Create;
        for var mI := 0 to Pred(mDataSet.FieldCount) do
          begin
            var mJSONValue : TJSONValue := nil;
            var mValorTag  := '';

            if (not mDataSet.Fields[mI].Visible) then
              Continue;

            mCampoTag := mDataSet.Fields[mI].FieldName;

            case mDataSet.Fields[mI].DataType of
              {$REGION 'Boolean'}
              TFieldType.ftBoolean:
                begin
                  if mDataSet.Fields[mI].AsBoolean then
                    mJSONValue := TJSONTrue.Create
                  else
                    mJSONValue := TJSONFalse.Create;
                end;
              {$ENDREGION}
              {$REGION 'Integer...'}
              TFieldType.ftInteger, TFieldType.ftSmallint, TFieldType.ftShortint:
                mJSONValue := TJSONNumber.Create(mDataSet.Fields[mI].AsInteger);
              TFieldType.ftLargeint:
                begin
                  var mValorLargeInt := mDataSet.Fields[mI].AsLargeInt;
                  if (mValorLargeInt > 100) then
                    mJSONValue := TJSONString.Create(mValorLargeInt.ToString)
                  else
                    mJSONValue := TJSONNumber.Create(mValorLargeInt);
                end;
              {$ENDREGION}
              {$REGION 'Float...'}
              TFieldType.ftSingle, TFieldType.ftFloat, TFieldType.ftFMTBcd, TFieldType.ftBCD, TFieldType.ftCurrency:
                mJSONValue := TJSONNumber.Create(mDataSet.Fields[mI].AsFloat);
              {$ENDREGION}
              {$REGION 'Data / DateTime / Time'}
              TFieldType.ftDate:
                begin
                  if (not mDataSet.Fields[mI].IsNull) then
                    mJSONValue := TJSONString.Create(FormatDateTime('mm/dd/yy', mDataSet.Fields[mI].AsDateTime))
                  else
                    mJSONValue := TJSONNull.Create
                end;
              TFieldType.ftTimeStamp, TFieldType.ftDateTime:
                begin
                  if (not mDataSet.Fields[mI].IsNull) then
                    mJSONValue := TJSONString.Create(FormatDateTime('mm/dd/yy', mDataSet.Fields[mI].AsDateTime))
                  else
                    mJSONValue := TJSONNull.Create
                end;
              TFieldType.ftTime:
                begin
                  if (not mDataSet.Fields[mI].IsNull) then
                    mJSONValue := TJSONString.Create(FormatDateTime('HH:ss', mDataSet.Fields[mI].AsDateTime))
                  else
                    mJSONValue := TJSONNull.Create
                end;
              {$ENDREGION}
              {$REGION 'Graphic / blob / Stream'}
              TFieldType.ftBlob:
                begin
                  if (not mDataSet.Fields[mI].IsNull) then
                    mJSONValue := TJSONString.Create(TBlobField(mDataSet.Fields[mI]).AsString)
                  else
                    mJSONValue := TJSONNull.Create;
                end;
              TFieldType.ftGraphic, TFieldType.ftStream:
                begin
                  var mMemStream := TMemoryStream.Create;
                  try
                    TBlobField(mDataSet.Fields[mI]).SaveToStream(mMemStream);
                    mMemStream.Position := 0;
                    var mStrStream := TStringStream.Create;
                    try
                      TNetEncoding.Base64.Encode(mMemStream, mStrStream);
                      mJSONValue := TJSONString.Create(mStrStream.DataString);
                    finally
                      mStrStream.Free;
                    end;
                  finally
                    mMemStream.Free;
                  end;
                end
              {$ENDREGION}
              {$REGION 'String / WideString / Memo / ftWideMemo / outros...'}
            else
              begin
                if (not mDataSet.Fields[mI].IsNull) then
                  mJSONValue := TJSONString.Create(mDataSet.Fields[mI].AsWideString)
                else
                  mJSONValue := TJSONNull.Create
              end;
              {$ENDREGION}
            end;

            {$REGION 'Validar campo NULL / zerado'}
            if (not mJSONValue.Null) then
              begin
                try
                  mValorTag := mJSONValue.GetValue<String>;
                except
                  mValorTag := mJSONValue.ToString;
                  if (Pos('"', mValorTag) > 0) then
                    mValorTag := StringReplace(mValorTag, '"', '', [rfReplaceAll]);
                end;
              end;
            {$ENDREGION}

            if Assigned(mJSONValue) then
              mJSONObjeto.AddPair(TJSONPair.Create(mCampoTag, mJSONValue));
          end;

        if Assigned(mJSONObjeto) and (mJSONObjeto.Count > 0) then
          Result.AddElement(mJSONObjeto);

        if (mId > 0) and (mDataSet.FindField('id') <> nil) then
          Break
        else
          mDataSet.Next;
      end;
  finally
    mDataSet.First;
    mDataSet.EnableControls;
  end;
end;

class function TConversorJson.DataSetParaJSONObject(mDataSet: TDataSet; mId: Integer = -1): TJSONObject;
begin
  Result := nil;
  if (not Assigned(mDataSet)) or (mDataSet.IsEmpty) then
    Exit;

  mDataSet.DisableControls;
  try
    mDataSet.First;
    if (mId >= 0) and (mDataSet.FindField('id') <> nil) then
      mDataSet.Locate('id', mId, []);

    if mDataSet.Eof then
      Exit;

    var mJSONObjeto := TJSONObject.Create;
    for var mI := 0 to Pred(mDataSet.FieldCount) do
    begin
      var mCampo := mDataSet.Fields[mI];
      var mJSONValue: TJSONValue;

      if (not mCampo.Visible) then
        Continue;

      var mCampoTag := mCampo.FieldName;
      case mCampo.DataType of
        ftBoolean : mJSONValue := TJSONBool.Create(mCampo.AsBoolean);
        ftInteger, ftSmallint, ftShortint: mJSONValue := TJSONNumber.Create(mCampo.AsInteger);
        ftLargeint: mJSONValue := TJSONNumber.Create(mCampo.AsLargeInt);
        ftSingle, ftFloat, ftFMTBcd, ftBCD, ftCurrency: mJSONValue := TJSONNumber.Create(mCampo.AsFloat);
        ftDate, ftTimeStamp, ftDateTime:
          begin
            if (not mCampo.IsNull) then
              mJSONValue := TJSONString.Create(FormatDateTime('yyyy-mm-dd hh:nn:ss', mCampo.AsDateTime))
            else
              mJSONValue := TJSONNull.Create;
          end;

        ftBlob:
          begin
            if (not mCampo.IsNull) then
              mJSONValue := TJSONString.Create(TBlobField(mCampo).AsString)
            else
              mJSONValue := TJSONNull.Create;
          end;

        ftGraphic, ftStream:
          begin
            var mMemoryStream := TMemoryStream.Create;
            try
              TBlobField(mCampo).SaveToStream(mMemoryStream);
              mMemoryStream.Position := 0;
              var mTexto := TStringStream.Create;
              try
                TNetEncoding.Base64.Encode(mMemoryStream, mTexto);
                mJSONValue := TJSONString.Create(mTexto.DataString);
              finally
                mTexto.Free;
              end;
            finally
              mMemoryStream.Free;
            end;
          end;

      else
        if (not mCampo.IsNull) then
          mJSONValue := TJSONString.Create(mCampo.AsString)
        else
          mJSONValue := TJSONNull.Create;
      end;

      mJSONObjeto.AddPair(mCampoTag, mJSONValue);
      Result := mJSONObjeto;
    end;
  finally
    mDataSet.EnableControls;
  end;
end;

class function TConversorJson.ObjetoParaJSONObject(mObjeto: TObject): TJSONObject;
begin
  Result := nil;
  if (not Assigned(mObjeto)) then
    Exit;

  var mJsonObj  := TJSONObject.Create;
  var mContexto := TRttiContext.Create;
  try
    for var mPropriedade in mContexto.GetType(mObjeto.ClassType).GetProperties do
      begin
        if (not mPropriedade.IsReadable) then
          Continue;

        var mValor := mPropriedade.GetValue(mObjeto);

        if mValor.IsObject then
          begin
            var mJsonArray := TJSONArray.Create;
            var mLista     := TObjectList<TObject>(mValor.AsObject);

            for var mObj in mLista do
              mJsonArray.AddElement(ObjetoParaJSONObject(mObj));

            mJsonObj.AddPair(mPropriedade.Name, mJsonArray);
            Continue;
          end;

        case mPropriedade.PropertyType.TypeKind of
          tkInteger, tkInt64             : mJsonObj.AddPair(mPropriedade.Name, TJSONNumber.Create(mValor.AsInteger));
          tkString, tkUString, tkWString : mJsonObj.AddPair(mPropriedade.Name, mValor.AsString);
          tkFloat:
            begin
              if SameText(mPropriedade.PropertyType.Name, 'TDateTime') then
                mJsonObj.AddPair(mPropriedade.Name, FormatDateTime('yyyy-mm-dd hh:nn:ss', mValor.AsExtended))
              else if SameText(mPropriedade.PropertyType.Name, 'TDate') then
                mJsonObj.AddPair(mPropriedade.Name, FormatDateTime('yyyy-mm-dd', mValor.AsExtended))
              else
                mJsonObj.AddPair(mPropriedade.Name, TJSONNumber.Create(mValor.AsExtended));
            end;
          tkEnumeration:
            begin
              if mPropriedade.PropertyType.Handle = TypeInfo(Boolean) then
                mJsonObj.AddPair(mPropriedade.Name, TJSONBool.Create(mValor.AsBoolean))
              else
                mJsonObj.AddPair(mPropriedade.Name, TJSONString.Create(mValor.ToString));
            end;
        else
          mJsonObj.AddPair(mPropriedade.Name, mValor.ToString);
        end;
      end;

    Result := mJsonObj;
  finally
    mContexto.Free;
  end;
end;

class procedure TConversorJson.JSONArrayParaObjeto(mFmt: TDataSet; mJsonArray: TJSONArray);
begin
  if (not Assigned(mFmt)) then
    raise Exception.Create('DataSet não informado');

  if (not Assigned(mJsonArray)) then
    raise Exception.Create('JSONArray não informado');

  var mTipoCampo: TFieldType;
  var mTempDate : TDateTime;

  if (mFmt.FieldCount = 0) and (mJsonArray.Count > 0) then
    begin
      var mJsonObj := mJsonArray.Items[0] as TJSONObject;

      for var mPair in mJsonObj do
        begin
          if (mPair.JsonValue is TJSONNumber) then
            begin
              var mNomeCampo := LowerCase(mPair.JsonString.Value);

              if (Pos(',', mPair.JsonValue.Value) > 0) or
                 mNomeCampo.Contains('preco') or
                 mNomeCampo.Contains('valor') or
                 mNomeCampo.Contains('total') then
                mTipoCampo := ftFloat
              else
                mTipoCampo := ftInteger;
            end
          else if (mPair.JsonValue is TJSONBool) then
            mTipoCampo := ftBoolean
          else if TryISO8601ToDate(mPair.JsonValue.Value, mTempDate)then
            mTipoCampo := ftDateTime
          else
            mTipoCampo := ftString;

          case mTipoCampo of
            ftString   : mFmt.FieldDefs.Add(mPair.JsonString.Value, ftString, 2000);
            ftFloat    : mFmt.FieldDefs.Add(mPair.JsonString.Value, ftFloat);
            ftInteger  : mFmt.FieldDefs.Add(mPair.JsonString.Value, ftInteger);
            ftBoolean  : mFmt.FieldDefs.Add(mPair.JsonString.Value, ftBoolean);
            ftDateTime : mFmt.FieldDefs.Add(mPair.JsonString.Value, ftDateTime);
          else
            mFmt.FieldDefs.Add(mPair.JsonString.Value, ftString, 2000);
          end;
        end;

      if (mFmt is TFDMemTable) then
        TFDMemTable(mFmt).CreateDataSet
      else
        mFmt.Open;
    end
  else if (not mFmt.Active) then
    begin
      if (mFmt is TFDMemTable) then
        TFDMemTable(mFmt).CreateDataSet
      else
        mFmt.Open;
    end;

  mFmt.DisableControls;
  try
    for var mJsonItem in mJsonArray do
      begin
        if (not (mJsonItem is TJSONObject)) then
          Continue;

        var mJSONObjeto := TJSONObject.ParseJSONValue(mJsonItem.ToString) as TJSONObject;
        mFmt.Append;

        for var mPair in mJSONObjeto do
          begin
            var mCampo := mFmt.FindField(mPair.JsonString.Value);
            if Assigned(mCampo) then
              begin
                 var mJSONValue := mJSONObjeto.GetValue(mCampo.FieldName);

                case mCampo.DataType of
                  ftString, ftWideString        : mCampo.AsString  := mJSONValue.Value;
                  ftInteger, ftSmallint, ftWord : mCampo.AsInteger := StrToIntDef(mJSONValue.Value, 0);
                  ftFloat, ftCurrency, ftBCD    : mCampo.AsFloat   := StrToFloatDef(mJSONValue.Value, 0.00);
                  ftBoolean                     : mCampo.AsBoolean := (mPair.JsonValue is TJSONBool) and TJSONBool(mPair.JsonValue).AsBoolean;
                  ftDate, ftDateTime:
                    begin
                      try
                        mCampo.AsDateTime := ISO8601ToDate(mJSONValue.Value);
                      except
                        mCampo.Clear;
                      end
                    end
                else
                  mCampo.AsString := mJSONValue.Value;
                end;
              end;
          end;

        mFmt.Post;
      end;
  finally
    mFmt.EnableControls;
  end;
end;

class procedure TConversorJson.JSONObjectParaObjeto(mObjeto: TObject; mJson: String);
begin
  var mJSONObject := TJSONObject.ParseJSONValue(mJson) as TJSONObject;

  if (not Assigned(mJSONObject)) then
    raise Exception.Create('JSON inválido');

  var mContexto := TRttiContext.Create;
  try
    for var mPropriedade in mContexto.GetType(mObjeto.ClassInfo).GetProperties do
      begin
        if (not mPropriedade.IsWritable) then
          Continue;

        var mJsonValue := mJSONObject.GetValue(mPropriedade.Name);
        if (not Assigned(mJsonValue)) then
          mJsonValue := mJSONObject.GetValue(mPropriedade.Name.ToLower);

        if (not Assigned(mJsonValue)) then
          Continue;

        case mPropriedade.PropertyType.TypeKind of
          tkString, tkUString, tkWString : mPropriedade.SetValue(mObjeto, mJsonValue.Value);
          tkFloat:
            begin
              if SameText(mPropriedade.PropertyType.Name, 'TDateTime') then
                mPropriedade.SetValue(mObjeto, StrToDateTime(mJsonValue.Value))
              else if SameText(mPropriedade.PropertyType.Name, 'TDate') then
                begin
                  var mData: TDateTime;
                  if TryISO8601ToDate(mJsonValue.Value, mData) then
                    mPropriedade.SetValue(mObjeto, mData);
                end
              else
                mPropriedade.SetValue(mObjeto, StrToFloat(mJsonValue.Value));
            end;
          tkInteger : mPropriedade.SetValue(mObjeto, StrToInt(mJsonValue.Value));
          tkInt64   : mPropriedade.SetValue(mObjeto, StrToInt64(mJsonValue.Value));
          tkEnumeration:
            begin
              if mPropriedade.PropertyType.Handle = TypeInfo(Boolean) then
                mPropriedade.SetValue(mObjeto, mJsonValue.Value.ToBoolean);
            end;
        end;
      end;
  finally
    mJSONObject.Free;
    mContexto.Free;
  end;
end;

{ TConexaoServer }

class function TConexaoServer.GetUrl(mTabela: String; mSituacaoCadastro: TSituacaoCadastro; mId: String = ''): String;
begin
  Result := 'http://' + gIp + ':' + gPortaHttp.ToString + cgUrlBase + cgVersaoServer + mTabela;

  if (mSituacaoCadastro in [scaAlterando, scaExcluindo]) then
    Result := Result + mId;
end;

class function TConexaoServer.RESTExecutar(mVerbo: TTipoVerboHTTP; mURLCompleta, mBody: String; mTimeOut: Integer;
  out mOutRespostaCodigoStatus: Integer; out mOutRespostaTexto: String; mTipoAutenticacao: TTipoAutenticacao;
  mHeader: String = ''): Boolean;
begin
  var mACBrHTTP       := TACBrHTTP.Create(nil);
  var mMSRequisicao   := TMemoryStream.Create;
  var mRequisicaoBody := TStringList.Create;
  try
    mRequisicaoBody.Text := mBody;
    mRequisicaoBody.SaveToStream(mMSRequisicao, TEncoding.UTF8);
    mACBrHTTP.HTTPSend.Clear;
    mACBrHTTP.HTTPSend.Document.LoadFromStream(mMSRequisicao);
    mACBrHTTP.HTTPSend.MimeType := 'application/json; charset=utf-8';
    if (not mHeader.Trim.IsEmpty) then
      mACBrHTTP.HTTPSend.Headers.Text := mHeader;
    if (mTimeOut > 0) then
      mACBrHTTP.TimeOut := mTimeOut;
    try
      case mVerbo of
        tvhGet: mACBrHTTP.HTTPMethod('GET', mURLCompleta);
        tvhPost: mACBrHTTP.HTTPPost(mURLCompleta);
        tvhPut: mACBrHTTP.HTTPPut(mURLCompleta);
        tvhDelete: mACBrHTTP.HTTPMethod('DELETE', mURLCompleta);
      end;
      var mRespostaContentType := '';
      for var mI := 0 to Pred(mACBrHTTP.HTTPSend.Headers.Count) do
        begin
          if StartsText('Content-Type:', mACBrHTTP.HTTPSend.Headers[mI]) then
            begin
              mRespostaContentType := Copy(mACBrHTTP.HTTPSend.Headers[mI], 14, MaxInt);
              Break;
            end;
        end;
      var mRespostaUTF8 := (Pos('UTF-8', mRespostaContentType.ToUpper) > 0) or
                           (Pos('application/json', mRespostaContentType.ToLower) > 0);
      var mResposta := DecodeToString(mACBrHTTP.HTTPResponse, mRespostaUTF8);
      if (not mResposta.Trim.IsEmpty and (mResposta.Trim[1] in ['[', '{'])) then
        mOutRespostaTexto := DecodificarJSON(mResposta)
      else
        mOutRespostaTexto := mResposta;
      mOutRespostaCodigoStatus := mACBrHTTP.HTTPSend.ResultCode;
    except
      on E: Exception do
       var mT := E.Message;
    end;
  finally
    FreeAndNil(mACBrHTTP);
    FreeAndNil(mMSRequisicao);
    FreeAndNil(mRequisicaoBody);
  end;
end;





end.
