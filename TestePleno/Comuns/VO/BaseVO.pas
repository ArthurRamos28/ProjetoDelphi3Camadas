unit BaseVO;

interface

uses
  System.Generics.Collections, System.RTTI, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Param,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, System.Classes, System.TypInfo, System.Variants, DateUtils, System.JSON,
  System.StrUtils, LibUtil;

type
  TCampoBanco = class(TCustomAttribute)
  strict private
    FCampo: String;
    FTipo: TTipoCampo;
  public
    constructor Create(mCampo: String; mTipo: TTipoCampo);

    property Campo: String read FCampo write FCampo;
    property Tipo: TTipoCampo read FTipo write FTipo;
  end;

  TNomeTabela = class(TCustomAttribute)
  strict private
    FNome: String;
  public
    constructor Create(mNome: String);

    property Nome: String read FNome write FNome;
  end;

  TBaseVO = class
  private
    procedure SetarPropriedadeInterno(mDataSet: TDataSet);
  public
    function GetSQL(const mTipoResultSQL: TTipoResultSQL; mIgnorarRetornarAoInserir: Boolean = False): String;
    procedure JSONObjectParaObjeto(mJsonString: String);
    procedure SetarPropriedade(mQuery: TFDQuery); overload;
    procedure SetarPropriedade(mFmt: TFDMemTable; mFmtItem: TFDMemTable = nil); overload;
    function ObjetoParaJSONArray: TJSONArray;
    function ObjetoParaJSONObject: TJSONObject;
  end;

  TListaBaseVO = TObjectList<TBaseVO>;

  function GetSQLClasse(mClasseVO: TClass; mTipoResultSQL: TTipoResultSQL; mBaseVO: TBaseVO = nil;
    mIgnorarRetornarAoInserir: Boolean = False; mWherePK: Boolean = True): String;
  function GetNomeTabelaClasse(mClasseVO: TClass): String;
  procedure SetParametrosBaseVO(mBaseVO: TBaseVO; mQuery: TFDQuery);
  function GetFieldTypePorTypeKind(mTypeInfo: PTypeInfo): TFieldType;

implementation

uses
  LancamentoItemVO;

{ TCampoBanco }

constructor TCampoBanco.Create(mCampo: String; mTipo: TTipoCampo);
begin
  FCampo := mCampo;
  FTipo  := mTipo
end;

function TBaseVO.GetSQL(const mTipoResultSQL: TTipoResultSQL; mIgnorarRetornarAoInserir: Boolean = False): String;
begin
  Result := GetSQLClasse(Self.ClassType, mTipoResultSQL, Self, mIgnorarRetornarAoInserir);
end;

procedure TBaseVO.JSONObjectParaObjeto(mJsonString: String);
begin
  TConversorJson.JSONObjectParaObjeto(Self, mJsonString);
end;

function TBaseVO.ObjetoParaJSONArray: TJSONArray;
begin
  Result := TConversorJson.ObjetoParaJSONArray(Self);
end;

function TBaseVO.ObjetoParaJSONObject: TJSONObject;
begin
  Result := TConversorJson.ObjetoParaJSONObject(Self);
end;

procedure TBaseVO.SetarPropriedade(mQuery: TFDQuery);
begin
  SetarPropriedadeInterno(mQuery);
end;

procedure TBaseVO.SetarPropriedade(mFmt: TFDMemTable; mFmtItem: TFDMemTable = nil);
begin
  var mContexto := TRttiContext.Create;
  try
    for var mPropriedade in mContexto.GetType(Self.ClassInfo).GetProperties do
      begin
        if (not mPropriedade.IsWritable) then
          Continue;

        var mNomeCampo := mPropriedade.Name;

        if SameText(mPropriedade.Name, 'ListaLancamentoItemVO') and Assigned(mFmtItem) then
          begin
            var mListaVO := TListaLancamentoItemVO.Create(True);
            mFmtItem.First;
            while (not mFmtItem.Eof) do
              begin
                var mItem := TLancamentoItemVO.Create;
                mItem.SetarPropriedade(mFmtItem);
                mListaVO.Add(mItem);
                mFmtItem.Next;
              end;

            mPropriedade.SetValue(Self, TValue.From(mListaVO));
            Continue;
          end;

        var mCampo := mFmt.FindField(mNomeCampo);

        if (mCampo = nil) then
          Continue;

        if mCampo.IsNull then
          Continue;

        case mPropriedade.PropertyType.TypeKind of
          tkInteger    : mPropriedade.SetValue(Self, mCampo.AsInteger);
          tkInt64      : mPropriedade.SetValue(Self, mCampo.AsLargeInt);
          tkFloat      :
            if SameText(mPropriedade.PropertyType.Name, 'TDateTime') then
              mPropriedade.SetValue(Self, mCampo.AsDateTime)
            else if SameText(mPropriedade.PropertyType.Name, 'TDate') then
              mPropriedade.SetValue(Self, mCampo.AsDateTime)
            else
              mPropriedade.SetValue(Self, mCampo.AsFloat);

          tkString, tkUString, tkWString : mPropriedade.SetValue(Self, mCampo.AsString);
          tkEnumeration :
            if (mPropriedade.PropertyType.Handle = TypeInfo(Boolean)) then
              mPropriedade.SetValue(Self, mCampo.AsBoolean);
        else
          mPropriedade.SetValue(Self, TValue.FromVariant(mCampo.Value));
        end;
      end;
  finally
    mContexto.Free;
  end;
end;

procedure TBaseVO.SetarPropriedadeInterno(mDataSet: TDataSet);
begin
  var mContexto := TRttiContext.Create;
  try
    for var mPropriedade in mContexto.GetType(Self.ClassInfo).GetProperties do
      begin
        if (not mPropriedade.IsWritable) then
          Continue;

        for var mAtributo in mPropriedade.GetAttributes do
          begin
            if (not (mAtributo is TCampoBanco)) then
              Continue;

            var mNomeCampo := TCampoBanco(mAtributo).Campo;
            var mCampo     := mDataSet.FindField(mNomeCampo);

            if (mCampo = nil) then
              Continue;

            if mCampo.IsNull then
              Continue;

            case mPropriedade.PropertyType.TypeKind of
              tkInteger    : mPropriedade.SetValue(Self, mCampo.AsInteger);
              tkInt64      : mPropriedade.SetValue(Self, mCampo.AsLargeInt);
              tkFloat      :
                begin
                  if SameText(mPropriedade.PropertyType.Name, 'TDateTime') then
                    mPropriedade.SetValue(Self, mCampo.AsDateTime)
                  else if SameText(mPropriedade.PropertyType.Name, 'TDate') then
                    mPropriedade.SetValue(Self, mCampo.AsDateTime)
                  else
                    mPropriedade.SetValue(Self, mCampo.AsFloat);
                end;
              tkString, tkUString, tkWString : mPropriedade.SetValue(Self, mCampo.AsString);
              tkEnumeration :
                if (mPropriedade.PropertyType.Handle = TypeInfo(Boolean)) then
                  mPropriedade.SetValue(Self, mCampo.AsBoolean);
            else
              mPropriedade.SetValue(Self, TValue.FromVariant(mCampo.Value));
            end;
          end;
      end;
  finally
    mContexto.Free;
  end;
end;

function GetFieldTypePorTypeKind(mTypeInfo: PTypeInfo): TFieldType;
begin
  case mTypeInfo.Kind of
    tkInteger     : Result := ftInteger;
    tkInt64       : Result := ftLargeInt;
    tkFloat       :
      begin
        if SameText(mTypeInfo.Name, 'TDate') then
          Result := ftDate
        else
          Result := ftFloat;
      end;
    tkClass       : Result := ftBlob;
    tkString,
    tkUString,
    tkWString     : Result := ftString;
    tkEnumeration :
      begin
        if SameText(mTypeInfo.Name, 'Boolean') then
          Result := ftBoolean
        else
          Result := ftInteger;
      end;
  else
    Result := ftUnknown;
  end;
end;

procedure SetParametrosBaseVO(mBaseVO: TBaseVO; mQuery: TFDQuery);
begin
  var mParametro := mQuery.Params;
  var mContexto  := TRttiContext.Create;
  try
    for var mPropriedade in mContexto.GetType(mBaseVO.ClassInfo).GetProperties do
      begin
        for var mAtributo in mPropriedade.GetAttributes do
          begin
            if (not (mAtributo is TCampoBanco)) then
              Continue;

            var mNomeCampo := TCampoBanco(mAtributo).Campo.Trim;
            if (Trim(mNomeCampo) = '') then
              Continue;

            var mParam := mParametro.FindParam(mNomeCampo);
            if (mParam = nil) then
              Continue;

            var mValor := mPropriedade.GetValue(mBaseVO);

            if (mParam.DataType = ftUnknown) then
              mParam.DataType := GetFieldTypePorTypeKind(mPropriedade.PropertyType.Handle);

            case mParam.DataType of
              ftBoolean     : mParam.AsBoolean  := mValor.AsBoolean;
              ftFloat       : mParam.AsFloat    := mValor.AsExtended;
              ftDate        : mParam.AsDate     := DateOf(mValor.AsExtended);
              ftDateTime    : mParam.AsDateTime := RecodeMilliSecond(mValor.AsExtended, 0);
              ftLargeInt    : mParam.AsLargeInt := mValor.AsInt64;
              ftInteger     : mParam.AsInteger  := mValor.AsInteger;
              ftString,
              ftWideString,
              ftMemo        : mParam.AsString := mValor.AsString;
            else
              mParam.Value  := mValor.AsVariant;
            end;
          end;
      end;
  finally
    mContexto.Free;
  end;
end;

function GetNomeTabelaClasse(mClasseVO: TClass): String;
begin
  Result := '';

  var mContexto := TRttiContext.Create;
  try
    for var mAtributo in mContexto.GetType(mClasseVO).GetAttributes do
      begin
        if (mAtributo is TNomeTabela) then
          begin
            Result := TNomeTabela(mAtributo).Nome;
            Exit;
          end;
      end;
  finally
    mContexto.Free;
  end;
end;

function GetSQLClasse(mClasseVO: TClass; mTipoResultSQL: TTipoResultSQL; mBaseVO: TBaseVO = nil;
  mIgnorarRetornarAoInserir: Boolean = False; mWherePK: Boolean = True): String;
begin
  Result              := '';
  var mSQLCampos      := '';
  var mSQLParametros  := '';
  var mCampoPK        := '';
  var mNomeCampoBanco : String    := '';
  var mSQLRetornarCamposAoInserir := '';

  var mNomeTabela := GetNomeTabelaClasse(mClasseVO);
  var mContexto   := TRttiContext.Create;
  try
    for var mPropriedade in mContexto.GetType(mClasseVO.ClassInfo).GetProperties do
      begin
        for var mAtributo in mPropriedade.GetAttributes do
          begin
            if (mAtributo is TCampoBanco) then
              begin
                mNomeCampoBanco := TCampoBanco(mAtributo).Campo;
                if (Trim(mNomeCampoBanco) = '') then
                  Continue;

                if (mTipoResultSQL in [trsAlterar, trsExcluir]) and (Pos('_id', mNomeCampoBanco) > 0) then
                  begin
                    mCampoPK := mNomeCampoBanco;
                    Continue;
                  end;

                mSQLCampos := JuntarString(mSQLCampos, mNomeCampoBanco, ', ');

                if (mTipoResultSQL = trsAlterar) then
                  mSQLCampos     := mSQLCampos + ' = :' + mNomeCampoBanco
                else if (mTipoResultSQL in [trsInserir, trsInserirAlterar]) then
                  mSQLParametros := JuntarString(mSQLParametros, ':' + mNomeCampoBanco, ', ');

                if (mTipoResultSQL in [trsInserir, trsInserirAlterar]) then
                  begin
                    if (Trim(mSQLRetornarCamposAoInserir) <> '') then
                      mSQLRetornarCamposAoInserir := mSQLRetornarCamposAoInserir + ', ';

                    mSQLRetornarCamposAoInserir := mSQLRetornarCamposAoInserir +  mNomeCampoBanco;
                  end;
              end;
          end;
      end;

    if (mTipoResultSQL = trsInserir) then
      begin
        Result := 'INSERT INTO ' + mNomeTabela + ' ' +
                  '(' + mSQLCampos + ') ' +
                  'VALUES ' +
                  '(' + mSQLParametros + ') ';

        if (Trim(mSQLRetornarCamposAoInserir) <> '') then
          Result := Result +
                    'RETURNING ' + mSQLRetornarCamposAoInserir;
      end
    else if (mTipoResultSQL = trsAlterar) and (Trim(mSQLCampos) <> '') then
      begin
        Result := 'UPDATE ' + mNomeTabela + ' SET ' + mSQLCampos;
        if mWherePK then
          Result := Result +
                    ' WHERE (' + mCampoPK + ' = :' + mCampoPK +')';
      end
    else if (mTipoResultSQL = trsExcluir) then
      begin
        Result := 'DELETE FROM ' + mNomeTabela;
        if mWherePK then
          Result := Result +
                    ' WHERE (' + mCampoPK + ' = :' + mCampoPK +')';
      end
    else if (mTipoResultSQL = trsBuscar) then
      Result := 'SELECT ' + mSQLCampos + ' ' +
                'FROM ' + mNomeTabela
    else if (mTipoResultSQL = trsInserirAlterar) then
      Result := 'UPDATE OR INSERT INTO ' + mNomeTabela + ' ' +
                '(' + mSQLCampos + ') ' +
                'VALUES ' +
                '(' + mSQLParametros + ') ';
  finally
    mContexto.Free;
  end;
end;

{ TNomeTabela }

constructor TNomeTabela.Create(mNome: String);
begin
  FNome := mNome;
end;

end.
