<#
.SYNOPSIS
    Checks current day of week against valid days of week.

.DESCRIPTION
    This runbook checks the current day of week against a listing of valid days of
    the week in order to identify if today is a valid day.  It requires a list of
    valid days of the week in comma-separated format with ranges accepted.

    Returns $true if the current day of week falls within the valid days of week
    identified and $false if it does not.

.PARAMETER ValidDaysOfWeek
    Valid days of the week as a comma-separated list.  Days of week can be
    passed as numbers (0 through 6 for Sunday through Saturday) or string days so 
    long as enough characters are provided to uniquely identify the day of week 
    (e.g. "s" is not unique where "sa" or "su" is).  Ranges can also be provided 
    in the format of startday-stopday.

.PARAMETER MinutesOffset
    Minutes to offset from UTC/GMT time.  Default offset is 0.  If desire is to
    check days of week based on a local time, the minutes offset can be used to
    take that local time into consideration.  For example, if Eastern Standard Time
    is desired, apply an offset of -300.

.EXAMPLE
    .\Function-CheckDaysOfWeek -ValidDaysOfWeek "Mon-Fri" -MinutesOffset -300

.EXAMPLE
    .\Function-CheckDaysOfWeek -ValidDaysOfWeek "Monday,Wednesday,Friday"

.EXAMPLE
    .\Function-CheckDaysOfWeek -ValidDaysOfWeek "0-2,4,6"

.EXAMPLE
    if (.\Function-CheckDaysOfWeek -ValidDaysOfWeek "Mon-Fri") { #my $true code here } else { #my $false code here }

.NOTES
    AUTHOR: Jeffrey Fanjoy
    LASTEDIT: Nov 24, 2015
#>

Param (
    [Parameter(Mandatory)]
    [string]$ValidDaysOfWeek,
    [Parameter(Mandatory=$false)]
    [int]$MinutesOffset = 0
)

Write-Verbose ("Entering Function-CheckDaysOfWeek")

Write-Verbose ("`$ValidDaysOfWeek [{0}]" -f $ValidDaysOfWeek)
Write-Verbose ("`$MinutesOffset [{0}]" -f $MinutesOffset)

# Get the current day of week
$CurrentDate = (Get-Date).ToUniversalTime()
Write-Verbose ("Current date as returned by Get-Date is {0} UTC/GMT." -f $CurrentDate)
Write-Verbose ("Current day of week without offset is {0}." -f $CurrentDate.DayOfWeek)
Write-Verbose ("Current date with offset applied is {0}." -f $CurrentDate.AddMinutes($MinutesOffset))
Write-Verbose ("Current day of week with offset applied is {0}." -f $CurrentDate.AddMinutes($MinutesOffset).DayOfWeek)
$CurrentDoW = $CurrentDate.AddMinutes($MinutesOffset).DayOfWeek

# Split the valid days of week passed into an array
$ValidDowArray = $ValidDaysOfWeek.Split(",")

$ValidDoW = @()
# Match each array element against a valid DayOfWeek property
foreach ($DoW in $ValidDowArray) {
    Write-Verbose ("Processing valid day of week argument: {0}" -f $DoW)
    # Check if a day range was passed by looking for a - character
    if ($DoW -match "-") {
        Write-Verbose ("Day of week range identified, constructing valid days.")
        $DoWRange = $DoW.Split("-")
        [dayofweek]$StartingDow = $DoWRange[0].Trim()
        [dayofweek]$EndingDow = $DoWRange[1].Trim()
        Write-Verbose ("`$StartingDow [{0}], `$EndingDow [{1}]" -f $StartingDow, $EndingDow)
        # Add all the days from start of range to end
        for ($d=$StartingDow.value__; $d -le $EndingDow.value__; $d++) {
            # Add the day into the listing of valid days of the week
            Write-Verbose ("Adding valid day of week argument {0}" -f $d)
            $ValidDow += [dayofweek]$d
        }
    } else {
        # Add the day into the listing of valid days of the week
        Write-Verbose ("Adding valid day of week argument: {0}" -f $DoW)
        $ValidDoW += [dayofweek]($DoW.Trim())
    }
}
foreach ($DoW in $ValidDoW) { Write-Verbose ("Valid day of week: {0}" -f $DoW.ToString()) }

# Check if the current day of week is in the valid days of week
if ($CurrentDoW -in $ValidDoW) { 
    Write-Verbose ("Current day of week is valid.")
    $true 
} else { 
    Write-Verbose ("Current day of week is NOT valid.")
    $false 
}

Write-Verbose ("Exiting Function-CheckDaysOfWeek")
