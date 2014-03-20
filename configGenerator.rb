require 'set'

def methodeTotale(donnees)
    baskets = {}
    #on initialise le hash
    donnees.getZones.each do |zone|
        baskets['zone'] = []
    end
    #on assigne les capteurs à un ou plusieurs backets
    donnees.getCapteurs.each do |capt|
        capt.getZones.each do |cz|
            baskets[cz.to_s] =  capt
        end 
    end
    return baskets
                .reduce { |x, y| x.product y }
                .map    { |x| x.flatten.uniq }



end

def methode1(donnees)
    sols = []
    zones = Set.new(donnees.getZones)

    for i in 0..(donnees.size - 1)
        capt1 = donnees.getCapteurs[i]
        for j in i..(donnees.size - 1)
            capt2 = donnees.getCapteurs[j]
            tmpzones = Set.new(capt1.getZones)
            tmpzones.merge(capt2.getZones)
            if tmpzones == zones
                sols.push [capt1, capt2]
            end
        end
    end
    return sols

end

def generateConfigurations(donnees)
    return methodeTotale donnees
    #return methode1(donnees)
end