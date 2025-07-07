unit uDMImagem;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls;

type
  TDMImagem = class(TDataModule)
    img16x16: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMImagem: TDMImagem;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
