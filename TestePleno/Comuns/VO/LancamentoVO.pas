unit LancamentoVO;

interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  BaseVO, LibUtil, LancamentoItemVO;

type
  [TNomeTabela('lancamento')]
  TLancamentoVO = class(TBaseVO)
  private
    FNomeCliente: String;
    FId: Integer;
    FValorTotal: Double;
    FDataCadastro: TDate;
    FIdCliente: Integer;
    FListaLancamentoItemVO: TListaLancamentoItemVO;
  public
    constructor Create;
    destructor Destroy; override;

    [TCampoBanco('lan_id', tcInteger)]
    property Id: Integer read FId write FId;

    [TCampoBanco('lan_data', tcDate)]
    property DataCadastro: TDate read FDataCadastro write FDataCadastro;

    [TCampoBanco('lan_cli_id', tcInteger)]
    property IdCliente: Integer read FIdCliente write FIdCliente;

    [TCampoBanco('lan_cli_nome', tcString)]
    property NomeCliente: String read FNomeCliente write FNomeCliente;

    [TCampoBanco('lan_valor_total', tcFloat)]
    property ValorTotal: Double read FValorTotal write FValorTotal;

    property ListaLancamentoItemVO: TListaLancamentoItemVO read FListaLancamentoItemVO write FListaLancamentoItemVO;
  end;

  TListaLancamentoVO = TObjectList<TLancamentoVO>;

implementation



{ TLancamentoVO }

constructor TLancamentoVO.Create;
begin
  inherited;

  FListaLancamentoItemVO := TListaLancamentoItemVO.Create(True);
end;

destructor TLancamentoVO.Destroy;
begin
  FListaLancamentoItemVO.Free;

  inherited;
end;

end.
