param($installPath, $toolsPath, $package, $project)

# This is the MSBuild targets file to add
$targetsFileName = 'talifun.crusher.msbuild.targets'
$projectPath = [System.IO.Path]::GetDirectoryName($project.FullName)
$targetsPath = [System.IO.Path]::Combine($projectPath, targetsFileName)

# Need to load MSBuild assembly if it's not loaded yet.
Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'

# Grab the loaded MSBuild project for the project
$msbuild = [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1

# Make the path to the targets file relative.
$projectUri = new-object Uri('file://' + $project.FullName)
$targetUri = new-object Uri('file://' + $targetsPath)
$relativePath = $projectUri.MakeRelativeUri($targetUri).ToString().Replace([System.IO.Path]::AltDirectorySeparatorChar, [System.IO.Path]::DirectorySeparatorChar)

# Add the import and save the project
$msbuild.Xml.AddImport($relativePath) | out-null
$project.Save()