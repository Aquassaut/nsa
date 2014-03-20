def getDonneesFromStdin
    puts "Entrez le nombre de zones : "
    nz = $stdin.gets.chomp().to_i
    d = Donnees.new((1..nz).to_a)
    over = false
    i = 1
    until over
        puts "Entrez les zones observées par le capteur"
        zones = $stdin.gets.chomp().split().map { |e|  e.to_i }
        puts "#{zones}"

        puts "Entrez la durée de vie du capteur"
        lifetime = $stdin.gets.chomp.to_i

        c = Capteur.new i, zones, lifetime
        d.addCapteur c

        puts "Voulez vous ajouter un capteur ?"
        over = ! ['Y', 'O'].member?($stdin.gets.upcase().chomp)
        i += 1
    end
    return d
end