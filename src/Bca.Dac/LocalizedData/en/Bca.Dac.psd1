@{
    Global                 = @{
        Debug = @{
            Entering = "Entering '{0}'"
            Leaving  = "Leaving '{0}'"
        }
    }

    ImportModule           = @{
        Error = @{
            ImportError = @{
                Message = "Failed to import function '{0}': {1}"
                Target  = "Function"
            }
        }
    }

    GetDacDllPath          = @{
        Verbose = @{
            FromModule = "Looking for module 'SqlServer'."
        }
    }

    PublishUnpublishDacPac = @{
        Verbose = @{
            LoadDll       = "Loading Dac DLL from '{0}'."
            LoadProfile   = "Loading Dac profile from '{0}'."
            DeployOption  = "Setting deployment option '{0}' to '{1}'."
            LoadService   = "Loading Dac service to '{0}'."
            LoadPackage   = "Loading Dac package from '{0}'."
            TestDb        = "Testing if database '{0}' already exists."
            DriftReport   = "Creating drift report."
            NoDriftReport = "Not creating drift report, either option was not specified or database '{0}' does not exist yet." 
            KillSessions  = "Terminating sessions to database '{0}'."
            DeployReport  = "Creating deployment report."
            DeployScript  = "Creating deployment script."
            DeployDacPac  = "Deploying database package '{0}'."
            UnregisterDac = "Unregistering package '{0}' with mode '{1}'."
            ReportPath    = "Deployment reports and scripts, if any, can be found under '{0}'."
        }

        Warning = @{
            CantKillSessions = "Could not kill sessions to database '{0}'."
            DbDoesntExist    = "Database '{0}' does not exist yet."
        }
    }

    SetDacDllPath          = @{
        Verbose = @{
            FromDirectory = "Looking for DLL in directory '{0}'."
        }

        Error   = @{
            NotFound = @{
                Message = "The DLL was not found in directory '{0}'."
                Target  = "DacDll"
            }
            NotValid = @{
                Message = "The file '{0}' is not a valid DLL file."
                Target  = "DacDll"
            }
        }
    }

    SetSqlProjectVersion   = @{
        Verbose = @{
            Directory      = "Getting .sqlproj files in folder '{0}' (Recurse: {1})."
            File           = "Adding .sqlproj file '{0}'."
            ProcessFile    = "Processing file '{0}'."
            ROFlag         = "Removing 'ReadOnly' flag if present."
            VersionUpdated = "Version updated to {0} in file '{1}'."
        }

        Warning = @{
            NotSqlProj = "File '{0}' is not a .sqlproj file, it will be ignore."
        }
    }
}