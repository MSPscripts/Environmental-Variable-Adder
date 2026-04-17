I found myself irritated as I fiddle-faddled with adding environmental variables to my workstation that I wanted to persist, like dev environment API keys, file paths that I wanted Powershell scripts
to be able to reference when my profile was being loaded, or similar stuff.

If you don't need a variable in your machine or userspace to persist - not useful! You can throw environment (or regular) variables in your Powershell profile, you can easily access, enumerate, and manipulate
the environmental variables in your space with $env:[whatever] or "Set-Location Env:". But if you do need persistence, I found this to be more pleasant than remembering the syntax for the .NET
method of [Environment]::SetEnvironmentVariable()
