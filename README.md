Check Days of the Week
======================

            

This runbook checks the current day of week against a listing of valid days of the week in order to identify if today is a valid day.  It requires a list of valid days of the week in comma-separated format with ranges accepted.  Returns $true if
 the current day of the week falls within the valid dyas of week identified and $false if it does not.


Days of week can be passed as numbers (0 through 6 for Sunday through Saturday) or string days so long as enough characters are provided to uniquely identify the day of week (e.g. 's' is not unique where 'sa' or 'su' is).  Ranges can also be provided
 in the format of startday-stopday.


 




 




        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
