
# Windows Security Log Analysis
# Project: Windows Security Log Analysis & Brute-Force Investigation
# Purpose: Retrieve and summarize failed logon events (Event ID 4625)

Write-Host "`n=== Windows Security Log Analysis ===" -ForegroundColor Cyan

# Retrieve the latest 20 failed logon events
try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        Id      = 4625
    } -MaxEvents 20 -ErrorAction Stop

    # Display total retrieved events
    Write-Host "`nTotal failed logon events retrieved: $($events.Count)" -ForegroundColor Yellow

    # Extract relevant event fields
    $results = foreach ($event in $events) {
        [xml]$xml = $event.ToXml()
        $data = @{}

        foreach ($item in $xml.Event.EventData.Data) {
            $data[[string]$item.Name] = [string]$item.'#text'
        }

        [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            EventID     = $event.Id
            TargetUser  = $data['TargetUserName']
            LogonType   = $data['LogonType']
            Status      = $data['Status']
            SubStatus   = $data['SubStatus']
            SourceIP    = $data['IpAddress']
        }
    }

    # Display investigation results
    Write-Host "`n=== Failed Logon Event Details ===" -ForegroundColor Cyan
    $results | Format-Table -AutoSize

    # Summarize events by Event ID
    Write-Host "`n=== Event Summary ===" -ForegroundColor Cyan
    $events | Group-Object Id |
        Select-Object Name, Count |
        Format-Table -AutoSize

}
catch {
    Write-Host "Unable to retrieve Security events: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Try running PowerShell as Administrator." -ForegroundColor Yellow
}
