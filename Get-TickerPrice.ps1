<#
    .DESCRIPTION
    Gives stock information to your terminal.

    .EXAMPLE
    .\Get-TickerPrice.ps1 -ApiKey KEY -Endpoint quote -Symbols "AMZN,SNAP,PINS,REGN,APD"

    .LINK
    https://www.yahoofinanceapi.com/tutorial

    .PARAMETER Symbols
    symbols are stock tickers that are separated by commas. eg. BTC-USD,AAPL,AMZN



#>


[CmdletBinding()]
    param (
        [string]$Symbols = "X.TO",

        [ValidateSet("quote", "trending")]
        [string]$Endpoint= "quote",
        [string]$Region = "US",
        [string]$ApiKey = ""
    )
    

# $ResponseData = $JsonPath | Select-Object $Tickerfields | Format-Table

switch($Endpoint){
    "quote"
    {
        $Query = "https://yfapi.net/v6/finance/$($Endpoint)?region=$($Region)&lang=en&symbols=$($Symbols)"
        $Tickerfields = @("shortName", "regularMarketPrice", "regularMarketChangePercent" )

    }
    "trending"
    {
       $Query =  "https://yfapi.net/v1/finance/$($Endpoint)/$($Region)"
       $Tickerfields = @("symbol")
    }

}    

Write-Host $Query

try
{
    $ApiResponse = ConvertFrom-Json (Invoke-WebRequest -Uri $Query -Headers @{"X-API-Key"="$($ApiKey)"})
    # This will only execute if the Invoke-WebRequest is successful.
}
catch
{
    $StatusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "Failed request. Response code: $($StatusCode)"
}


$QuoteResponseData = $ApiResponse.quoteResponse.result 
$TrendingResponseData = $ApiResponse.finance.result.quotes

switch($Endpoint){
    "quote"
        {
            $Data = $QuoteResponseData| Select-Object $Tickerfields | Format-Table
            $Data
        }
    "trending"
        {   
            $Data = $TrendingResponseData| Select-Object -Verbose  $Tickerfields | Format-Table
            $Data
        }
}

