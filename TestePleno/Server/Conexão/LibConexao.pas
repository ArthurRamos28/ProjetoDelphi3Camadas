unit LibConexao;

interface

uses
  System.Classes, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Param,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.DApt,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait;

type
  IConexao = interface
    function Query: TFDQuery;
  end;

  TConexao = class(TInterfacedObject, IConexao)
  private
    FQuery: TFDQuery;
  public
    destructor Destroy; override;

    class function Nova: TConexao;
    function Query: TFDQuery;
  end;

  TFDConnectionHelper = class Helper for TFDConnection
  public
    procedure TransacaoStart;
    procedure TransacaoCommit;
    procedure TransacaoRollback;
  end;

implementation

uses
  uDMConexaoBanco;

{ TConexao }

destructor TConexao.Destroy;
begin
  FreeAndNil(FQuery);

  inherited;
end;

class function TConexao.Nova: TConexao;
begin
  Result := Self.Create;
end;

function TConexao.Query: TFDQuery;
begin
  if (FQuery = nil) then
    begin
      FQuery            := TFDQuery.Create(nil);
      FQuery.Connection := DMConexaoBanco.fdConexao;
    end;

  Result := FQuery;
end;

{ TFDConnectionHelper }

procedure TFDConnectionHelper.TransacaoCommit;
begin
  Commit;
end;

procedure TFDConnectionHelper.TransacaoRollback;
begin
  Rollback;
end;

procedure TFDConnectionHelper.TransacaoStart;
begin
  if (not InTransaction) then
    StartTransaction;
end;

end.
