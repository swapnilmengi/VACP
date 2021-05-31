## SCRIPT WILL CHECK AND UPDATE AVAILABILITY STATUS FOR NEXT 4 DAYS FROM TODAY##

##Update Parameters Below##
    #Fetch District ID From https://apisetu.gov.in/public/marketplace/api/cowin#
$district_id = "123"
    #Create Slack WorkPlace and Webhook#
$slack_webhook= "https://slack.com"

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
    if ( $response.sessions[$i].available_capacity_dose1 -gt "0" )
    {
    Invoke-RestMethod -uri $slack_webhook -Method Post -body "{'text': 'Dose 1: $available_capacity slots of $available_vaccine available at $center_name for age group 18+ on $date_check'}" -ContentType 'application/json'
    }
    ##Uncomment Dose 2 below if required##

    #if ( $response.sessions[$i].available_capacity_dose2 -gt "0" )
    #{
    #Invoke-RestMethod -uri $slack_webhook -Method Post -body "{'text': 'Dose 2 $available_capacity slots of $available_vaccine available at $center_name for age group 18+ on $date_check'}" -ContentType 'application/json'
    #}
}
}}