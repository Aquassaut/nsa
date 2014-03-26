require 'set'


# Ici, on va créer des paniers : un par zone
# On met chaque capteur dans le/les paniers corresondant aux zones qu'ils
# observent.
# ensuite on fait un produit cartesien des paniers pour avoir toutes les
# configurations.
def methodeTotale(donnees)
    puts donnees.inspect
    sols = []
    baskets = {}
    #on initialise le hash
    donnees.getZones.each do |zone|
        baskets[zone] = []
    end
    #on assigne les capteurs à un ou plusieurs backets
    donnees.getCapteurs.each do |capt|
        capt.getZones.each do |cz|
            baskets[cz].push capt
        end 
    end
    sols = baskets
                .values
                .reduce { |x, y| x.product y }
                .map    { |x| Set.new x.flatten }
                .sort   { |x, y| x.size <=> y.size }
                .uniq
    return sols
end

# Ici, l'idée c'est de prendre le maximum de paire de capteurs qui voient
# toutes les zones. Ca peut donner une bonne partie des solutions dans les
# scénarios ou le nombre de zones / sensor est proche du nombre de zones total
# O(n^2) 
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

# On fait un passage sur tous les capteurs, on les ajoute à une liste et 
# on passe à la liste suivante quand toutes les zones sont remplies
# O(n)
def methode2(donnees)
    sols = []
    zones = Set.new donnees.getZones
    tzones = Set.new
    tconf = []
    donnees.getCapteurs.each do |x|
        #on ajoute le capteur à la configuration
        tconf.push x
        #On ajoute les zones du capteur aux 
        x.getZones.each do |z|
            tzones.add z
        end
        if zones == tzones
            sols.push tconf.clone
            tzones.clear
            tconf.clear
        end
    end
    return sols
end

#La même avec un ordre de pick random
def methode2random(donnees)
    sols = []
    zones = Set.new donnees.getZones
    tzones = Set.new
    tconf = []
    cl = donnees.getCapteurs.clone 
    while cl.size > 0 do
        #On tire au hazard, et supprime l'élément de la liste
        x = cl.delete cl.sample
        #on ajoute le capteur à la configuration
        tconf.push x
        #On ajoute les zones du capteur aux 
        x.getZones.each do |z|
            tzones.add z
        end
        if zones == tzones
            sols.push tconf.clone
            tzones.clear
            tconf.clear
        end
    end
    return sols
end

#Ici, l'idée c'est de découper les capteurs en deux
#bucket : les capteurs qui ont beaucoup de zones et les
#capteurs qui ont peu de zones. Ensuite, on parcoure
#les capteurs a beaucoup de zones et on les complète avec
#des capteurs à peu de zones
def methode3(donnees)
    sols = []
    zones = Set.new donnees.getZones

    sortedCapteurs = donnees.getCapteurs.sort {|x, y| x.getZones.size <=> y.getZones.size }
    #on met le "pivot" au milieu, ça peut être amélioré
    pivot = sortedCapteurs.size / 2
    petitsCapteurs = sortedCapteurs.slice 0, pivot
    grosCapteurs = sortedCapteurs.slice pivot, sortedCapteurs.size - 1

    grosCapteurs.each do |x|
        sol = [ x ]
        tzones = Set.new x.getZones
        petitsCapteurs.each do |y|
            break if tzones == zones
            unless tzones.superset? Set.new y.getZones
                y.getZones.each { |v| tzones.add v }
                sol.push petitsCapteurs.delete y
            end
        end
        sols.push sol if tzones == zones
    end
    return sols
end

#La méthode 3 mais avec un pick random
def methode3random(donnees)
    sols = []
    zones = Set.new donnees.getZones

    sortedCapteurs = donnees.getCapteurs.sort {|x, y| x.getZones.size <=> y.getZones.size }
    #on met le "pivot" au milieu, ça peut être amélioré
    pivot = sortedCapteurs.size / 2
    petitsCapteurs = sortedCapteurs.slice 0, pivot
    grosCapteurs = sortedCapteurs.slice pivot, sortedCapteurs.size - 1

    grosCapteurs.shuffle.each do |x|
        sol = [ x ]
        tzones = Set.new x.getZones
        petitsCapteurs.shuffle.each do |y|
            break if tzones == zones
            unless tzones.superset? Set.new y.getZones
                y.getZones.each { |v| tzones.add v }
                sol.push petitsCapteurs.delete y
            end
        end
        sols.push sol if tzones == zones
    end
    return sols

end

def generateConfigurations(donnees)
    return methodeTotale donnees
    return methode3random donnees
    return methode3 donnees
    return methode2random donnees
    return methode2 donnees
    return methode1 donnees
end
