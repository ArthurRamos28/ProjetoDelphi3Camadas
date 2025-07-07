unit ClienteVO;

interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  BaseVO, LibUtil;

type
  [TNomeTabela('cliente')]
  TClienteVO = class(TBaseVO)
  private
    FId: Integer;
    FNome: String;
    FBairro: String;
    FCpf: String;
    FCidade: String;
    FEndereco: String;
    FEstado: String;
    FAtivo: Boolean;
    FCep: String;
  public
    [TCampoBanco('cli_id', tcInteger)]
    property Id: Integer read FId write FId;

    [TCampoBanco('cli_nome', tcString)]
    property Nome: String read FNome write FNome;

    [TCampoBanco('cli_cpf', tcString)]
    property Cpf: String read FCpf write FCpf;

    [TCampoBanco('cli_endereco', tcString)]
    property Endereco: String read FEndereco write FEndereco;

    [TCampoBanco('cli_cep', tcString)]
    property Cep: String read FCep write FCep;

    [TCampoBanco('cli_bairro', tcString)]
    property Bairro: String read FBairro write FBairro;

    [TCampoBanco('cli_cidade', tcString)]
    property Cidade: String read FCidade write FCidade;

    [TCampoBanco('cli_estado', tcString)]
    property Estado: String read FEstado write FEstado;

    [TCampoBanco('cli_ativo', tcBoolean)]
    property Ativo: Boolean read FAtivo write FAtivo;
  end;

implementation

end.
