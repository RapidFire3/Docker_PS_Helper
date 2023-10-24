###########################################################################
#   Docker PowerShell Help Script
#   Author: Jeff Gardner
#
#   Used only for windows
###########################################################################




###########################################################################
#   If the user would like to load in a configuration file.
###########################################################################
#[xml]$configFile


###########################################################################
#   Docker Engine options. 
###########################################################################   
enum ContainerEngineOptions {
    windows
    linux
}


###########################################################################
#   This function is responsible for logging into the desired Docker 
#   registry.
###########################################################################
function Set-DockerRegistry
{
    [string]$private:dockerRegistry = "<DESIRED_REGISTRY>"

    ###########################################################################
    #   Display status.
    #
    #   String can be modified at the developer's discretion.
    ###########################################################################
    Write-Host "`n `t>>> Please enter in your credentials <<< `n" -ForegroundColor Green

    ###########################################################################
    #   Responsible for launching the web page where the user's API Key is 
    #   located. This will assist the user and eliminating the stem of them
    #   having to search for the search, resullting in a reduction of process 
    #   time. This is for projects that maybe using enterprise tools that 
    #   Utilizes API keys. Maybe not be needed if the user is just using an 
    #   individual account such as from dockerhub.
    ###########################################################################
    #Start-Process "<WEB-PAGE>"
    
    ###########################################################################
    #   Login to the desired regisrty.
    ###########################################################################
    docker login $dockerRegistry 
}

###########################################################################
#   This function is responsible for checking rather the Docker Daemon is 
#   running for the desired container operating system. If not, this 
#   function will switch to desired container.
###########################################################################
function Confirm-DockerWindowsContainers
{
    [CmdletBinding()]
    param(
        [ContainerEngineOptions]$DockerEngineOS = [ContainerEngineOptions]::linux
    )

    [string]$private:dockerApp          =   "C:\'Program Files'\Docker\Docker\resources\bin\docker.exe"
    [string]$private:dockerCLIApp       =   "C:\'Program Files'\Docker\Docker\dockercli.exe"

    ###########################################################################
    #   Responsible for getting the current operating system that the Docker 
    #   daemon is currently running in. Get this by utilizing the docker info
    #   command and just get the 'OSType' section from the returned list.
    ###########################################################################
    $private:dockerInfo = Invoke-Expression "$dockerApp info --format '{{ .OSType }}' "

    ###########################################################################
    #   Check the path for the Docker application and the Docker application
    #   exist. These two are needed to conduct the following operations.
    #
    #   I removed the the single quotes from the string because the "path" does 
    #   not actually contains single quotes.

    #   Added the single qupotes to escape the space if there are any.
    ###########################################################################   
    if( ( Test-Path -Path ( $dockerApp -replace "'", "" )) -and 
        ( Test-Path -Path ( $dockerCLIApp -replace "'", "" )))
    {
        ###########################################################################
        #   Check if the Docker daemon is running using the desired operating
        #   system engine.
        ###########################################################################  
        if( $dockerInfo -ne $DockerEngineOS ) 
        {
            ###########################################################################
            #   Display status.
            ###########################################################################
            Write-Host "`n `tSwitching to $DockerEngineOS Containers..." -ForegroundColor Cyan
            
            ###########################################################################
            #   Switch the Docker dameon to the desired operating system engine. 
            ###########################################################################
            switch( $DockerEngineOS ) {
                linux{ Invoke-Expression "$dockerCLIApp -SwitchLinuxEngine" }
                windows{ Invoke-Expression "$dockerCLIApp -SwitchWindowsEngine" }
            }

            ###########################################################################
            #   Display status.
            ###########################################################################
            Write-Host "`tYou have now been switched to $DockerEngineOS Containers.`n" -ForegroundColor Green
        }

        ###########################################################################
        #   Display status.
        ###########################################################################
        else {
            Write-Host "`tAlready using $DockerEngineOS Containers engine .`n" -ForegroundColor Green
        }
    }

    ###########################################################################
    #   If the Docker CLI path could not be located on the machine.
    ###########################################################################
    else {
        Write-Host "`tCould not locate the Docker CLI application.`n" -ForegroundColor Red
    }
}