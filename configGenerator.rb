require 'set'


# Ici, on va créer des paniers : un par zone
# On met chaque capteur dans le/les paniers corresondant aux zones qu'ils
# observent.
# ensuite on fait un produit cartesien des paniers pour avoir toutes les
# configurations.
def methodeTotale(donnees)
    sols = Set.new
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
    vals = baskets.values
    vals.delete_at(0).product(*vals) do |p|
        sols.add p.sort { |s, t| s.getName <=> t.getName }.uniq
    end
    return sols.to_a
end

# Ici, l'idée c'est de prendre le maximum de paire de capteurs qui voient
# toutes les zones. Ca peut donner une bonne partie des solutions dans les
# scénarios ou le nombre de zones / sensor est proche du nombre de zones total
# O(n^2) 
def methode1(donnees)
    sols = Set.new
    zones = Set.new(donnees.getZones)

    for i in 0..(donnees.size - 1)
        capt1 = donnees.getCapteurs[i]
        for j in i..(donnees.size - 1)
            capt2 = donnees.getCapteurs[j]
            tmpzones = Set.new(capt1.getZones)
            tmpzones.merge(capt2.getZones)
            if tmpzones == zones
                sols.add [capt1, capt2]
            end
        end
    end
    return sols.to_a

end

# On fait un passage sur tous les capteurs, on les ajoute à une liste et 
# on passe à la liste suivante quand toutes les zones sont remplies
# O(n)
def methode2(donnees)
    sols = Set.new
    zones = Set.new donnees.getZones
    tzones = Set.new
    tconf = Set.new
    donnees.getCapteurs.each do |x|
        #on ajoute le capteur à la configuration
        tconf.add x
        #On ajoute les zones du capteur aux 
        x.getZones.each do |z|
            tzones.add z
        end
        if zones == tzones
            sols.add tconf.clone
            tzones.clear
            tconf.clear
        end
    end
    return sols.to_a
end

#La même avec un ordre de pick random
def methode2random(donnees)
    sols = Set.new
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
            sols.add tconf.clone
            tzones.clear
            tconf.clear
        end
    end
    return sols.to_a
end

#Ici, l'idée c'est de découper les capteurs en deux
#bucket : les capteurs qui ont beaucoup de zones et les
#capteurs qui ont peu de zones. Ensuite, on parcoure
#les capteurs a beaucoup de zones et on les complète avec
#des capteurs à peu de zones
def methode3(donnees)
    sols = Set.new
    zones = Set.new donnees.getZones

    sortedCapteurs = donnees.getCapteurs.sort {|x, y| x.getZones.size <=> y.getZones.size }
    #on met le "pivot" au milieu, ça peut être amélioré
    pivot = sortedCapteurs.size / 2
    petitsCapteurs = sortedCapteurs.slice(0, pivot).clone
    grosCapteurs = sortedCapteurs.slice(pivot, sortedCapteurs.size - 1).clone

    grosCapteurs.each do |x|
        sol = Set.new [ x ]
        tzones = Set.new x.getZones
        petitsCapteurs.each do |y|
            break if tzones == zones
            unless tzones.superset? Set.new y.getZones
                y.getZones.each { |v| tzones.add v }
                sol.add petitsCapteurs.delete y
            end
        end
        sols.add sol if tzones == zones
    end
    return sols.to_a
end

#La méthode 3 mais avec un pick random
def methode3random(donnees)
    sols = Set.new
    zones = Set.new donnees.getZones

    sortedCapteurs = donnees.getCapteurs.sort {|x, y| x.getZones.size <=> y.getZones.size }
    #on met le "pivot" au milieu, ça peut être amélioré
    pivot = sortedCapteurs.size / 2
    petitsCapteurs = sortedCapteurs.slice(0, pivot).clone.shuffle
    grosCapteurs = sortedCapteurs.slice(pivot, sortedCapteurs.size - 1).clone.shuffle

    grosCapteurs.each do |x|
        sol = Set.new [ x ]
        tzones = Set.new x.getZones
        petitsCapteurs.each do |y|
            break if tzones == zones
            unless tzones.superset? Set.new y.getZones
                y.getZones.each { |v| tzones.add v }
                sol.add petitsCapteurs.delete y
            end
        end
        sols.add sol if tzones == zones
    end
    return sols.to_a
end

def filterElementaire(solutions)
    banned = []
    solutions.each do |sol|
        s = Set.new sol.map {|u| u.getName}
        solutions.each do |test|
            t = Set.new test.map {|u| u.getName}
            if s.proper_subset? t
                banned.push test
            end
        end
    end
    return solutions - banned
end

def generateConfigurations(donnees)
    return filterElementaire methodeTotale donnees
    #return filterElementaire methode2random donnees
    #return filterElementaire methode2 donnees
    #return filterElementaire methode3random donnees
    #return filterElementaire methode3 donnees
    #return filterElementaire methode1 donnees
end
