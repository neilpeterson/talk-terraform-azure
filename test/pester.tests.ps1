param (
    [string]$webSite
)

Describe 'Status Code' {
    $a = Invoke-WebRequest $webSite

    It 'A test that should be true' {
      $a.StatusCode | Should -Be 202
    }
  }