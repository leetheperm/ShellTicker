function Get-YahooFinanceResponse{
    param(
        [Parameter(Mandatory)]
        [string]$Query,
        [Parameter(Mandatory)]
        [string]$ApiKey    
    )

    try
    {
        $ApiResponse = ConvertFrom-Json (Invoke-WebRequest -Uri $Query -Headers @{"X-API-Key"="$($ApiKey)"})
        return $ApiResponse
    }
    catch
    {
        $StatusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "Failed request. Response code: $($StatusCode)"
        
    }
    return $null
}
