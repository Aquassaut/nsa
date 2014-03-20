require "json"
require_relative "dataModel"

def getDonneesFromFile(file)
    monhash = JSON.parse(IO.read(file))
    d = Donnees.new(monhash['zones'])
    i = 1
    monhash['capteurs'].each do |x|
        nom = "c" + i.to_s
        x['zones'].each do |z|
            unless d.getZones().member?(z)
                puts "La zones inspectée par le capteur #{nom} (#{x}) n'est pas dans la liste des zones autorisées (#{d.getZones})"
                exit
            end
        end
        d.addCapteur(Capteur.new(nom, x['zones'], x['lifetime']))
        i += 1
    end
    return d
end