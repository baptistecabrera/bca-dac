@{
    Global       = @{
        Debug = @{
            Entering = "Début de la fonction « {0} »"
            Leaving  = "Fin de la fonction « {0} »"
        }
    }

    ImportModule = @{
        Error = @{
            ImportError = @{
                Message = "Impossible d'importer la fonction « {0} »  : {1}"
                Target  = "Fonction"
            }
        }
    }

    GetDacDllPath          = @{
        Verbose = @{
            FromModule = "Looking for module « SqlServer »."
        }
    }

    PublishUnpublishDacPac = @{
        Verbose = @{
            LoadDll       = "Chargement de la DLL Dac depuis « {0} »."
            LoadProfile   = "Chargement du profil Dac depuis « {0} »."
            DeployOption  = "Assignation de l'option de de déploiement « {0} » à « {1} »."
            LoadService   = "Chargement du service dac vers « {0} »."
            LoadPackage   = "Chargement du paquet Dac depuis « {0} »."
            TestDb        = "Vérification de l'existence de la base de données « {0} »."
            DriftReport   = "Création du rapport de dérive."
            NoDriftReport = "Pas de création de rapport de dérive, l'option n'a pas été spécifiée ou la base de données « {0} » n'existe pas." 
            KillSessions  = "Déconnections des sessions sur la base de données « {0} »."
            DeployReport  = "Création du rapport de déploiement."
            DeployScript  = "Création du script de déploiement."
            DeployDacPac  = "Déploiement du paquet Dac « {0} »."
            UnregisterDac = "Désenregistrement du paquet Dac « {0} » avec le mode « {1} »."
            ReportPath    = "Les rapports et scripts de déploiement, si applicable, se trouvent dans « {0} »."
        }

        Warning = @{
            CantKillSessions = "Impossible de terminer les sessions sur la base de données « {0} »."
            DbDoesntExist    = "La base de données « {0} » n'existe pas."
        }
    }

    SetDacDllPath          = @{
        Verbose = @{
            FromDirectory = "Recherche de la DLL dans le répertoire « {0} »."
        }

        Error   = @{
            NotFound = @{
                Message = "La DLL n'a pas été trouvée dans le répertoire « {0} »."
                Target  = "DacDll"
            }
            NotValid = @{
                Message = "Le fichier « {0} » n'est pas un fichier DLL valide."
                Target  = "DacDll"
            }
        }
    }

    SetSqlProjectVersion   = @{
        Verbose = @{
            Directory      = "Récupération des fichiers .sqlproj dans le répertoire « {0} » (Récursif: {1})."
            File           = "Ajout du fichier .sqlproj « {0} »."
            ProcessFile    = "Traitement du fichier « {0} »."
            ROFlag         = "Suppression de l'attribut « ReadOnly » si présent."
            VersionUpdated = "Version mise à jour à {0} dans le fichier « {1} »."
        }

        Warning = @{
            NotSqlProj = "Le fichier « {0} » n'est pas un .sqlproj, il sera ignoré."
        }
    }
}