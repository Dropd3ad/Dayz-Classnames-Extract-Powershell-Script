function Extract-ClassNames {
    param (
        [string]$inputFilePath,
        [string]$outputFilePath
    )

    try {
        Clear-Host
        Write-Host "Extracting class names from $inputFilePath..."

        # Check if the input file exists
        if (-not (Test-Path $inputFilePath)) {
            Write-Host "Input file does not exist."
            return
        }

        # Read the content of the input file
        $content = Get-Content -Path $inputFilePath -Raw

        # Find the start index of "class CfgVehicles"
        $startIndex = $content.IndexOf("class CfgVehicles")

        # Set the end index to the end of the file
        $endIndex = $content.Length

        # Extract the content between "class CfgVehicles" and the end of the file
        $cfgVehiclesContent = $content.Substring($startIndex, $endIndex - $startIndex)

        # Find all occurrences of "class" within "class CfgVehicles"
        $classOccurrences = $cfgVehiclesContent -split "class " | Where-Object { $_ -ne "" }

        # Extract the class names without ';' or ':'
        $classNames = @()
        foreach ($occurrence in $classOccurrences) {
            $className = $occurrence.Split()[0].TrimEnd(';').TrimEnd(':')
            $classNames += $className
        }

        # Display the extracted class names
        Write-Host "Extracted class names:"
        $classNames | ForEach-Object { Write-Host $_ }

        # Write the extracted class names to the output file
        $classNames -join "`n" | Set-Content -Path $outputFilePath

        Write-Host "Classnames extracted and saved to $outputFilePath"
    } catch {
        Write-Host "An error occurred: $_"
    }
}

# Example usage
$inputFilePath = Read-Host "Enter the path to the input file"
$outputFilePath = Read-Host "Enter the path to the output file"
Extract-ClassNames -inputFilePath $inputFilePath -outputFilePath $outputFilePath
