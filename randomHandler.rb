$debug = true

def getDonneesFromRandom(seed)
    if seed == nil
        if $debug
            puts("Attention, debug est activé, seed non random")
            seed = 0xd3af3da1d5e1d97ffbd53aec9e32847e
        else
            seed = Random.new_seed
        end
        puts "le seed utilisé est : #{seed}"
    else
        seed = seed.to_i
    end

    prng = Random.new(seed)

    nzones = prng.rand 10 #il faut que ça aille JUSQU'A 1000 BOBBY
    ncapteurs = prng.rand 10 #il faut que ça aille JUSQU'A 1000 BOBBY

    d = Donnees.new (0..nzones).to_a

    tempd = []
    zonesACouvrir = Set.new d.getZones
    zonesCouvertes = Set.new

    while zonesCouvertes != zonesACouvrir do
        zonesCouvertes.clear
        tempd.clear
        for i in 0..ncapteurs
            czones = (0..nzones).to_a.sample(prng.rand(nzones - 1) + 1, random:prng)
            czones.each { |x| zonesCouvertes.add x } 
            lifetime = prng.rand 10 #il faut que ça aille JUSQU'A 1000 BOBBY
            c = Capteur.new i, czones, lifetime
            tempd.push c
        end
    end
    tempd.each { |x| d.addCapteur x }
    return d
end
