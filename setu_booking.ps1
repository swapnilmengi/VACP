## SCRIPT WILL BOOK THE AVAILABLE SLOT AS PER THE DETAILS ##

##Update Mobile Number, Secret, Beneficiaries, Google chrome path (for opening captcha) and slot time as per your convinience##

##Update Parameters Below##
    #Fetch District ID From https://apisetu.gov.in/public/marketplace/api/cowin#
$district_id = "123"

for($j = 1; $j -lt 5; $j++)
{
$date_check = (Get-Date).AddDays($j).ToString("dd-MM-yyyy")
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36")
$response = Invoke-RestMethod https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=$district_id"&"date=$date_check -Method 'GET' -Headers $headers

for($i = 0; $i -lt $response.sessions.Count; $i++)
{
if ( $response.sessions[$i].min_age_limit -eq 18 )
{
    $center_name=$response.sessions[$i].name
    $available_capacity=$response.sessions[$i].available_capacity_dose1
    $available_vaccine=$response.sessions[$i].vaccine
    $available_session=$response.sessions[$i].session_id
    $available_center=$response.sessions[$i].center_id
    if ( $response.sessions[$i].available_capacity_dose1 -gt "0" )
    {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36")

## Update Mobile Number and secret Below ##
    #Secret can be fetched from Browser Developer Tools -> Network activity when logging in#
$bod = @{
 secret= 'U2Fs*******=='
 mobile= '1234567890'
}
$body = $bod | ConvertTo-Json
$response = Invoke-RestMethod https://cdn-api.co-vin.in/api/v2/auth/generateMobileOTP -Method POST -Headers $headers -Body $body -ContentType 'application/json'
$tokens=$response.txnId

$otpinput = Read-Host "Enter OTP"
$stringAsStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.StreamWriter]::new($stringAsStream)
$writer.write("$otpinput")
$writer.Flush()
$stringAsStream.Position = 0
$hash = Get-FileHash -InputStream $stringAsStream | Select-Object Hash
$otpid = $hash.Hash.ToLower()
$bodi = @{txnId= $tokensotp= $otpid}
$up_body = $bodi | ConvertTo-Json
$headers.Add("Origin", "https://selfregistration.cowin.gov.in")
$headers.Add("Referer", "https://selfregistration.cowin.gov.in")
$headers.Add("Accept-Encoding", "gzip, deflate")
$up_response = Invoke-RestMethod https://cdn-api.co-vin.in/api/v2/auth/validateMobileOtp -Method POST -Headers $headers -Body $up_body -ContentType 'application/json'
$new_token = $up_response.token

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36")
$headers.Add("Authorization", "Bearer $new_token")

$svg = Invoke-RestMethod 'https://cdn-api.co-vin.in/api/v2/auth/getRecaptcha' -Method 'POST' -Headers $headers -ContentType 'application/json'
echo $svg.captcha > 'C:\Users\Public\svg.svg'

##Update Chrome Path Below if different##
start-process -FilePath 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList 'C:\Users\Public\svg.svg'

##Update Beneficiary, Dose and Slot Details Below##
$captchaid = Read-Host "Enter Captcha"
$book = @{
center_id= $available_center
dose= '1'
session_id= $available_session
beneficiaries= @('1234567890')
captcha= $captchaid
slot= '10:00AM-11:00AM'
}

$body = $book | ConvertTo-Json
Invoke-RestMethod 'https://cdn-api.co-vin.in/api/v2/appointment/schedule' -Method 'POST' -Headers $headers -Body $body -ContentType 'application/json'
exit
    }
}
}}
