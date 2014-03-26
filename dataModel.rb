class Capteur
    def initialize(nom, zones, lifetime)
        @nom = nom
        @zones = zones
        @lifetime = lifetime
    end
    def getZones()
        @zones
    end
    def getName()
        @nom
    end
    def getLifetime()
        @lifetime
    end
end

class Donnees
    def initialize(zones)
        @zones = zones
        @capteurs = []
    end
    def addCapteur(capteur)
        @capteurs.push(capteur)
    end
    def getZones()
        @zones
    end
    def getCapteurs()
        @capteurs
    end
    def size()
        @capteurs.size
    end
end
