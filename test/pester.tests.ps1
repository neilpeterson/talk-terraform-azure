param (
    [string]$webSite
)

Describe 'Status Code' {
    $a = Invoke-WebRequest $webSite

    It 'HTTP Status is 200' {
      $a.StatusCode | Should -Be 200
    }
  }