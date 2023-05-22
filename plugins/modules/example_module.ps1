#!powershell
# This is required for using Ansible modules in PowerShell.
# Ansible.Basic provides the basic Ansible module functions.
#AnsibleRequires -CSharpUtil Ansible.Basic

# Import the CommandUtil module which provides utility functions for working with commands in PowerShell.
#Requires -Module Ansible.ModuleUtils.CommandUtil

# Define the arguments your module will accept. 
$spec = @{
    options = @{
        # In this example module the path to the file to be written. It is a required argument.
        path = @{ type = "str"; required = $true }
        # The content to be written to the file.
        content = @{ type = "str"; required = $true }
    }
    # This allows the module to respect Ansible's 'check' mode which means it won't make actual changes but only indicate what changes it would make.
    supports_check_mode = $true
}

# Create an instance of the Ansible module with the given arguments.
$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)

# Checks if a file at the given path exists. This is just a helper function to make the code easier to read. Try splitting your code into smaller chunks.
function FileExists {
    param($path)
    return Test-Path -Path $path
}

# Reads the content of a file and compares it with the given content. Again, this is just a helper function.
function Compare-FileContent {
    param($path, $content)
    $currentContent = Get-Content -Path $path -Raw
    return $currentContent -eq ("$content`r`n")
}

# Checks if the state has changed to maintain idempotency.
# Idempotency ensures that running the same Ansible task multiple times will always produce the same result.
# For this module, the 'state' refers to the content of the file at the given path.
# The state has changed if either:
#   1) The file does not exist, in which case we need to create it and write the content, or 
#   2) The file exists, but its current content does not match the content we want to write.
# If neither condition is true (the file exists and already contains the desired content), 
# the module should do nothing, preserving idempotency.
function StateChanged {
    param($path, $content)

    if (-not (FileExists -path $path)) {
        return $true
    }
    else {
        return -not (Compare-FileContent -path $path -content $content)
    }
}

# This is the main function that executes the desired operation - writing the content to a file.
function Run {
    param($path, $content)
    Set-Content -Path $path -Value $content
}

try {
    # Extract the parameters passed to the module.
    $path = $module.Params.path
    $content = $module.Params.content

    # Check if the state has changed.
    if (StateChanged -path $path -content $content) {
        # If in check mode, just inform that the state would have changed without actually changing anything.
        if ($module.CheckMode) {
            $module.Result.message = "Check Mode: State would have been changed."
        }
        else {
            # If not in check mode, perform the operation and update the result.
            Run -path $path -content $content
            $module.Result.message = "State changed successfully."
        }
        $module.Result.changed = $true
    }
    else {
        # If state has not changed, then update the result accordingly.
        $module.Result.message = "State is already as desired."
        $module.Result.changed = $false
    }

    # If everything goes well, exit the module and return the result to Ansible.
    $module.ExitJson()
}
catch {
    # If there's any error, catch it and return a failure result to Ansible with the error message.
    # The FailJson method reports a failure to Ansible and terminates the module immediately. 
    $module.FailJson("An error occurred: $_")
}
