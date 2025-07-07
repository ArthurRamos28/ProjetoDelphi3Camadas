unit ProdutoVO;

interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  BaseVO, LibUtil;

type
  [TNomeTabela('produto')]
  TProdutoVO = class(TBaseVO)
  private
    FId: Integer;
    FAtivo: Boolean;
    FPreco: Double;
    FDescricao: String;
    FNome: String;
  public
    [TCampoBanco('pro_id', tcInteger)]
    property Id: Integer read FId write FId;

    [TCampoBanco('pro_nome', tcString)]
    property Nome: String read FNome write FNome;

    [TCampoBanco('pro_descricao', tcString)]
    property Descricao: String read FDescricao write FDescricao;

    [TCampoBanco('pro_preco', tcFloat)]
    property Preco: Double read FPreco write FPreco;

    [TCampoBanco('pro_ativo', tcBoolean)]
    property Ativo: Boolean read FAtivo write FAtivo;
  end;

implementation


end.
