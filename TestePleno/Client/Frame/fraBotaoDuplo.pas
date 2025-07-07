unit fraBotaoDuplo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ButtonGroup, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TufraBotaoDuplo = class(TFrame)
    pnl1: TPanel;
    shp1: TShape;
    btnOk: TButton;
    btnSair: TButton;
    pnl2: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
