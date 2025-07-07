unit LancamentoItemVO;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  BaseVO, LibUtil;

type
 [TNomeTabela('lancamento_item')]
  TLancamentoItemVO = class(TBaseVO)
  private
    FId: Integer;
    FValorUnitario: Double;
    FIdProduto: Integer;
    FValorTotal: Double;
    FQuantidade: Integer;
    FIdLancamento: Integer;
  public
    [TCampoBanco('lai_id', tcInteger)]
    property Id: Integer read FId write FId;

    [TCampoBanco('lai_lan_id', tcDate)]
    property IdLancamento: Integer read FIdLancamento write FIdLancamento;

    [TCampoBanco('lai_pro_id', tcInteger)]
    property IdProduto: Integer read FIdProduto write FIdProduto;

    [TCampoBanco('lai_quantidade', tcInteger)]
    property Quantidade: Integer read FQuantidade write FQuantidade;

    [TCampoBanco('lai_valor_unitario', tcFloat)]
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;

    [TCampoBanco('lai_valor_total', tcFloat)]
    property ValorTotal: Double read FValorTotal write FValorTotal;
  end;

  TListaLancamentoItemVO = TObjectList<TLancamentoItemVO>;

implementation

end.
