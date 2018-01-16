## The URL list to hit.
$URLList = @(
	'<url>',
	'<url>',
)
  
# Holds output results.
$Outputreport = "" 

# Loop through URLs and call each one.
Foreach ( $Uri in $URLList ) {
	$time = try{ 
		$request = $null 
		
		## Request the URI, and measure how long the response took. 
		$result1 = Measure-Command { $request = Invoke-WebRequest -Uri $uri -TimeoutSec 14800 } 
		$result1.TotalMilliseconds 
	} catch { 
		<# If the request generated an exception (i.e.: 500 server 
		error or 404 not found), we can pull the status code from the 
		Exception.Response property #> 
		$request = $_.Exception.Response 
		$time = -1 
	}

	# Prefix with "Error" if not a 200.
    	if( $request.StatusCode -ne "200" ) { 
		$Outputreport += "ERROR | " 
    	} 
	
	$Outputreport += "URL: $($uri) "
	$Outputreport += "StatusCode: $($request.StatusCode) "
	$Outputreport += "Time: $($time) "
    	$Outputreport += "Error: $($error) "
	$Outputreport += "`r`n "
}

# Add message to the log.
$Outputreport | out-file -append L:\logs\out.txt
