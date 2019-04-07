
/obj/effect/gibspawner
	var/sparks = 0 //whether sparks spread
	var/virusProb = 20 //the chance for viruses to spread on the gibs
	var/list/gibtypes = list() //typepaths of the gib decals to spawn
	var/list/gibamounts = list() //amount to spawn for each gib decal type we'll spawn.
	var/list/gibdirections = list() //of lists of possible directions to spread each gib decal type towards.
	var/fleshcolor
	var/bloodcolor

/obj/effect/gibspawner/Initialize(mapload, datum/dna/MobDNA, list/datum/disease/diseases)
	. = ..()

	if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
		to_chat(world, "<span class='danger'>Gib list length mismatch!</span>")
		return

	if(fleshcolor) src.fleshcolor = fleshcolor
	if(bloodcolor) src.bloodcolor = bloodcolor

	var/obj/effect/decal/cleanable/blood/gibs/gib = null

	if(sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, loc)
		s.start()

	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(loc, diseases)

				if(iscarbon(loc))
					var/mob/living/carbon/digester = loc
					digester.stomach_contents += gib

				if(MobDNA)
					var/list/blood_dna = MobDNA.get_blood_dna_list()
					gib.add_blood_DNA(blood_dna)

				// Apply human species colouration to masks.
				if(fleshcolor)
					gib.fleshcolor = fleshcolor
				if(bloodcolor)
					gib.color = bloodcolor

				gib.update_icon()

				if(istype(src, /obj/effect/gibspawner/generic)) // Probably a monkey
					gib.add_blood_DNA(list("Non-human DNA" = "A+"))
				var/list/directions = gibdirections[i]
				if(isturf(loc))
					if(directions.len)
						gib.streak(directions)

	return INITIALIZE_HINT_QDEL



/obj/effect/gibspawner/generic
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(2,2,1)

/obj/effect/gibspawner/generic/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 40, 1)
	gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH),list(EAST, NORTHEAST, SOUTHEAST, SOUTH), list())
	. = ..()

/obj/effect/gibspawner/human
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/up, /obj/effect/decal/cleanable/blood/gibs/down, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/body, /obj/effect/decal/cleanable/blood/gibs/limb, /obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(1,1,1,1,1,1,1)

/obj/effect/gibspawner/human/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 50, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	. = ..()


/obj/effect/gibspawner/humanbodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/core, /obj/effect/decal/cleanable/blood/gibs, /obj/effect/decal/cleanable/blood/gibs/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)

/obj/effect/gibspawner/humanbodypartless/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 50, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	. = ..()


/obj/effect/gibspawner/xeno
	gibtypes = list(/obj/effect/decal/cleanable/blood/xenoblood/gibs/up, /obj/effect/decal/cleanable/blood/xenoblood/gibs/down, /obj/effect/decal/cleanable/blood/xenoblood/gibs, /obj/effect/decal/cleanable/blood/xenoblood/gibs, /obj/effect/decal/cleanable/blood/xenoblood/gibs/body, /obj/effect/decal/cleanable/blood/xenoblood/gibs/limb, /obj/effect/decal/cleanable/blood/xenoblood/gibs/core)
	gibamounts = list(1,1,1,1,1,1,1)

/obj/effect/gibspawner/xeno/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 60, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs, list())
	. = ..()


/obj/effect/gibspawner/xenobodypartless //only the gibs that don't look like actual full bodyparts (except torso).
	gibtypes = list(/obj/effect/decal/cleanable/blood/xenoblood/gibs, /obj/effect/decal/cleanable/blood/xenoblood/gibs/core, /obj/effect/decal/cleanable/blood/xenoblood/gibs, /obj/effect/decal/cleanable/blood/xenoblood/gibs/core, /obj/effect/decal/cleanable/blood/xenoblood/gibs, /obj/effect/decal/cleanable/blood/xenoblood/gibs/torso)
	gibamounts = list(1, 1, 1, 1, 1, 1)


/obj/effect/gibspawner/xenobodypartless/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 60, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, list())
	. = ..()

/obj/effect/gibspawner/larva
	gibtypes = list(/obj/effect/decal/cleanable/blood/xenoblood/gibs/larva, /obj/effect/decal/cleanable/blood/xenoblood/gibs/larva, /obj/effect/decal/cleanable/blood/xenoblood/gibs/larva/body, /obj/effect/decal/cleanable/blood/xenoblood/gibs/larva/body)
	gibamounts = list(1, 1, 1, 1)

/obj/effect/gibspawner/larva/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 60, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST), list(), GLOB.alldirs)
	. = ..()

/obj/effect/gibspawner/larvabodypartless
	gibtypes = list(/obj/effect/decal/cleanable/blood/xenoblood/gibs/larva, /obj/effect/decal/cleanable/blood/xenoblood/gibs/larva, /obj/effect/decal/cleanable/blood/xenoblood/gibs/larva)
	gibamounts = list(1, 1, 1)

/obj/effect/gibspawner/larvabodypartless/Initialize()
	playsound(src, 'sound/effects/blobattack.ogg', 60, 1)
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST), list())
	. = ..()

/obj/effect/gibspawner/robot
	sparks = 1
	gibtypes = list(/obj/effect/decal/cleanable/robot_debris/up, /obj/effect/decal/cleanable/robot_debris/down, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris, /obj/effect/decal/cleanable/robot_debris/limb)
	gibamounts = list(1,1,1,1,1,1)

/obj/effect/gibspawner/robot/Initialize()
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), GLOB.alldirs, GLOB.alldirs)
	gibamounts[6] = pick(0,1,2)
	. = ..()
