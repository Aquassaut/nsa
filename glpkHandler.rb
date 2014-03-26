require "rglpk"

def computeOptimalSolution(donnees, lstConf)
    #La  liste des capteurs
    capteurs = donnees.getCapteurs

    #Le nombre de capteurs définit le nombre de ligne de contraintes
    nbContraintes = donnees.getCapteurs.size
    #Le nombre de configurations définit le nombre d'inconnu (temps d'allumage)
    nbInconnus = lstConf.size

    #On va stocker tout ça sous la forme d'une matrice
    matrice = Array.new
    for i in 0..nbContraintes-1
        matrice.push(Array.new)
    end


    for i in 0..nbContraintes-1
        for j in 0..nbInconnus-1
            if lstConf[j].include?(capteurs[i]) 
                matrice[i].push(1)
            else
                matrice[i].push(0)
            end
        end
    end

    #A ce stade là on a une jolie matrice qui correspond 

    #Il faut maintenant configurer rglpk avec les bonnes données
    
    #On crée un problème, le but est la maximisation
    p = Rglpk::Problem.new
    p.name = "choucroute"
    p.obj.dir = Rglpk::GLP_MAX

    #On ajoute les lignes de contraintes
    name = "a"
    rows = p.add_rows(nbContraintes)
    for i in 0..nbContraintes-1
        rows[i].name = name
        rows[i].set_bounds(Rglpk::GLP_UP,0,capteurs[i].getLifetime)
        name = name.next
    end

    #On ajoute les colonnes => inconnus
    indice = 1
    cols = p.add_cols(nbInconnus)
    for i in 0..nbInconnus-1
        cols[i].name = "t".concat(indice.to_s)
        cols[i].set_bounds(Rglpk::GLP_LO,0.0,0.0)
        indice += 1 #Pour toi Jerem <3
    end

    #On set les coeffs de l'équation probleme
    coefs = Array.new
    for i in 0..nbInconnus-1
        coefs.push(1)
    end
    p.obj.coefs = coefs

    #On set maintenant les coeffs dans les équations de contraintes
    p.set_matrix(matrice.flatten)

    #On lance le calcule
    p.simplex

    #On récupère les solution
    puts "z = #{p.obj.get}"
    for i in 0..nbInconnus-1
        puts "#{cols[i].name} = #{cols[i].get_prim}"
    end
end
