object DMConexaoServer: TDMConexaoServer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 409
  Width = 924
  object DSServer: TDSServer
    AutoStart = False
    Left = 56
    Top = 24
  end
  object DSAuthenticationManager: TDSAuthenticationManager
    OnUserAuthenticate = DSAuthenticationManagerUserAuthenticate
    Roles = <>
    Left = 152
    Top = 24
  end
  object DSHTTPService: TDSHTTPService
    OnHTTPTrace = DSHTTPServiceHTTPTrace
    Server = DSServer
    Filters = <>
    AuthenticationManager = DSAuthenticationManager
    Left = 56
    Top = 96
  end
end
