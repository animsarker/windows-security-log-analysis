Windows Security Log Analysis & Brute-Force Investigation

1. Project Overview

This project demonstrates basic security event monitoring and authentication-failure investigation using Windows Security Logs, Event Viewer, and PowerShell.

A controlled series of failed login attempts was generated against a dedicated local test account to examine how Windows records authentication failures.

2. Objectives

Understand Windows Security auditing.

Identify and examine failed logon events (Event ID 4625).

Interpret authentication-related event fields.

Retrieve and analyze security events using PowerShell.

Document findings using a basic SOC investigation approach.

3. Lab Environment

Component

Details

Operating System

Windows 10 Pro

Log Source

Windows Security Log

Analysis Tools

Event Viewer, PowerShell

Test Account

Dedicated local lab account

Event ID

4625

4. Investigation Process

Verified that Windows Logon auditing was enabled for Success and Failure events.

Generated controlled failed login attempts against the dedicated lab account.

Located Event ID 4625 in Windows Event Viewer.

Examined the General and XML event details.

Retrieved matching security events using PowerShell.

Counted the retrieved failed authentication events.

5. Key Event Findings

Field

Observed Value

Event ID

4625

Event Type

Audit Failure

Target Account

SOC-LabUser

Logon Type

2 (Interactive)

Status

0xC000006D

SubStatus

0xC000006A

Source Address

::1 (IPv6 loopback)

Failure Reason

Unknown user name or bad password

6. PowerShell Analysis

The following command was used to retrieve failed logon events:

$events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id = 4625
} -MaxEvents 20

$events | Select-Object TimeCreated, Id, Message | Format-List

The following command was used to count the retrieved events:

$events | Group-Object Id |
Select-Object Name, Count

Observed event count: 5

7. Security Analysis

Event ID 4625 indicates an unsuccessful logon attempt.

The observed status code (0xC000006D) represents a general logon failure, while substatus (0xC000006A) indicates an incorrect password.

Logon Type 2 indicates an interactive local logon attempt. The source address ::1 represents the IPv6 loopback address, indicating that the observed attempt originated locally rather than from a remote network address.

Repeated failed authentication events can be an indicator of password-guessing or brute-force activity. However, these events were deliberately generated as part of this controlled lab exercise and should not be classified as a real-world attack.

8. Conclusion

This investigation demonstrated how Windows records failed authentication attempts and how Event Viewer and PowerShell can be used to retrieve and examine security events.

The exercise provided practical exposure to Windows security auditing, event-field interpretation, basic log analysis, and security investigation documentation.

No real-world malicious activity was established by this controlled test.

9. Tools & Technologies

Windows 10 Pro

Windows Event Viewer

Windows Security Auditing

PowerShell

Windows Event ID 4625