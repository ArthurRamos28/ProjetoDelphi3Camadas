unit BaseDAO;

interface

uses

  LibUtil, BaseVO, System.SysUtils;

type
  TBaseDAO = class
    class procedure Inserir(const mBaseVO: TBaseVO);
    class procedure Alterar(const mBaseVO: TBaseVO);
    class procedure Excluir(const mBaseVO: TBaseVO);
  end;

implementation

uses
  LibConexao, uDMConexaoBanco;

{ TBaseDAO }

class procedure TBaseDAO.Inserir(const mBaseVO: TBaseVO);
begin
  var mQuery := TConexao.Nova.Query;
  try
    DMConexaoBanco.fdConexao.TransacaoStart;

    mQuery.SQL.Add(mBaseVO.GetSQL(trsInserir));
    SetParametrosBaseVO(mBaseVO, mQuery);

    if (not mQuery.Prepared) then
      mQuery.Prepare;

    mQuery.Open;

    if (mQuery.FieldCount > 0) then
      mBaseVO.SetarPropriedade(mQuery);

    mQuery.Close;

    DMConexaoBanco.fdConexao.TransacaoCommit;
  except
    On E: Exception do
      begin
        DMConexaoBanco.fdConexao.TransacaoRollback;
        var m := E.Message;
      end;
  end;
end;

class procedure TBaseDAO.Alterar(const mBaseVO: TBaseVO);
begin
  var mQuery := TConexao.Nova.Query;
  try
    DMConexaoBanco.fdConexao.TransacaoStart;

    mQuery.SQL.Add(mBaseVO.GetSQL(trsAlterar));
    SetParametrosBaseVO(mBaseVO, mQuery);

    if (not mQuery.Prepared) then
      mQuery.Prepare;

    mQuery.ExecSQL;

    if (mQuery.FieldCount > 0) then
      mBaseVO.SetarPropriedade(mQuery);

    mQuery.Close;

    DMConexaoBanco.fdConexao.TransacaoCommit;
  except
    On E: Exception do
      begin
        DMConexaoBanco.fdConexao.TransacaoRollback;
        var m := E.Message;
      end;
  end;
end;

class procedure TBaseDAO.Excluir(const mBaseVO: TBaseVO);
begin
  var mQuery := TConexao.Nova.Query;
  try
    DMConexaoBanco.fdConexao.TransacaoStart;

    mQuery.SQL.Add(mBaseVO.GetSQL(trsExcluir));
    SetParametrosBaseVO(mBaseVO, mQuery);

    if (not mQuery.Prepared) then
      mQuery.Prepare;

    mQuery.ExecSQL;

    if (mQuery.FieldCount > 0) then
      mBaseVO.SetarPropriedade(mQuery);

    mQuery.Close;

    DMConexaoBanco.fdConexao.TransacaoCommit;
  except
    On E: Exception do
      begin
        DMConexaoBanco.fdConexao.TransacaoRollback;
        var m := E.Message;
      end;
  end;
end;

end.
