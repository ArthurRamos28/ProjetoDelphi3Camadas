program SistemaVendasTeste;

uses
  Vcl.Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {frmPrincipal},
  uDMImagem in 'DataModule\uDMImagem.pas' {DMImagem: TDataModule},
  uFrmCadastroBase in 'uFrmCadastroBase.pas' {frmCadastroBase},
  fraBotaoDuplo in 'Frame\fraBotaoDuplo.pas' {ufraBotaoDuplo: TFrame},
  uFrmCadastroCliente in 'uFrmCadastroCliente.pas' {FrmCadastroCliente},
  uFrmPDV in 'uFrmPDV.pas' {FrmPDV},
  uFrmRelatorioVenda in 'Relatorio\uFrmRelatorioVenda.pas' {FrmRelatorioVenda},
  uFrmCadastroProduto in 'uFrmCadastroProduto.pas' {FrmCadastroProduto},
  LibUtil in '..\LibUtil.pas',
  BaseVO in '..\Comuns\VO\BaseVO.pas',
  LancamentoItemVO in '..\Comuns\VO\LancamentoItemVO.pas',
  LancamentoVO in '..\Comuns\VO\LancamentoVO.pas';

{$R *.res}




begin
  if (not ArquivoConexao) then
    CriarArquivoServer;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
