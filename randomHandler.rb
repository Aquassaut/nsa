$debug = true

def getDonneesFromRandom(seed)
    if seed == nil
        if $debug
            puts("Attention, debug est activé, seed non random")
            seed = 0xd3af3da1d5e1d97ffbd53aec9e32847e
        else
            seed = Random.new_seed
            puts "le seed utilisé est : #{seed}"
        end
    else
        seed = seed.to_i
    end

    prng = Random.new(seed)

    nzones = prng.rand 10 #il faut que ça aille JUSQU'A 1000 BOBBY
    ncapteurs = prng.rand 10 #il faut que ça aille JUSQU'A 1000 BOBBY

    d = Donnees.new nzones

    for i in 0..ncapteurs
        czones = (0..nzones).to_a.sample(prng.rand(nzones), random:prng)
        lifetime = prng.rand 10 #il faut que ça aille JUSQU'A 1000 BOBBY
        c = Capteur.new 1, czones, lifetime
        d.addCapteur c
    end


    puts(d.inspect)


end