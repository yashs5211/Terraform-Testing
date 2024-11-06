parameters:
  - name: projectName
    displayName: "Enter project name"
    type: string
    default: "SampleProject"
  - name: environment
    displayName: "Select environment"
    type: string
    default: "dev"
  - name: version
    displayName: "Specify version"
    type: string
    default: "1.0.0"

jobs:
  - job: ReplacePlaceholders
    steps:
      - task: PowerShell@2
        inputs:
          targetType: 'inline'
          script: |
            # Read the template content
            $templatePath = "$(Build.SourcesDirectory)\template.json"
            $jsonContent = Get-Content -Path $templatePath -Raw

            # Replace placeholders with runtime parameter values
            $jsonContent = $jsonContent -replace '\$\{projectName\}', "$(projectName)"
            $jsonContent = $jsonContent -replace '\$\{environment\}', "$(environment)"
            $jsonContent = $jsonContent -replace '\$\{version\}', "$(version)"

            # Output the updated JSON file
            $outputPath = "$(Build.ArtifactStagingDirectory)\output.json"
            $jsonContent | Out-File -FilePath $outputPath -Encoding utf8
          
      - publish: $(Build.ArtifactStagingDirectory)/output.json
        artifact: updatedJson

