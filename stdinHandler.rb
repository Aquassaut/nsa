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

        puts "Voulez vous ajouter un capteur ?"
        over = ! ['Y', 'O'].member?($stdin.gets.upcase().chomp)
    end
end