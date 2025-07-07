program Server;
{$APPTYPE GUI}



uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  frmPrincipal in 'frmPrincipal.pas' {frmServer},
  ConexaoServer in 'Conexão\ConexaoServer.pas' {DMConexaoServer: TDataModule},
  RotaBase in 'Rotas\RotaBase.pas',
  uDMConexaoBanco in 'Conexão\uDMConexaoBanco.pas' {DMConexaoBanco: TDataModule},
  LibConexao in 'Conexão\LibConexao.pas',
  ProdutoRota in 'Rotas\ProdutoRota.pas',
  BaseVO in '..\Comuns\VO\BaseVO.pas',
  ProdutoVO in '..\Comuns\VO\ProdutoVO.pas',
  BaseDAO in '..\Comuns\DAO\BaseDAO.pas',
  ProdutoDAO in '..\Comuns\DAO\ProdutoDAO.pas',
  LibUtil in '..\LibUtil.pas',
  ClienteDAO in '..\Comuns\DAO\ClienteDAO.pas',
  ClienteVO in '..\Comuns\VO\ClienteVO.pas',
  ClienteRota in 'Rotas\ClienteRota.pas',
  LancamentoVO in '..\Comuns\VO\LancamentoVO.pas',
  LancamentoRota in 'Rotas\LancamentoRota.pas',
  LancamentoItemVO in '..\Comuns\VO\LancamentoItemVO.pas',
  LancamentoDAO in '..\Comuns\DAO\LancamentoDAO.pas',
  LancamentoItemDAO in '..\Comuns\DAO\LancamentoItemDAO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDMConexaoServer, DMConexaoServer);
  Application.CreateForm(TDMConexaoBanco, DMConexaoBanco);
  Application.CreateForm(TfrmServer, frmServer);
  Application.Run;
end.
