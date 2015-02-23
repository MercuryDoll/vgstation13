#define SOLID 1
#define LIQUID 2
#define GAS 3

#define REM REAGENTS_EFFECT_MULTIPLIER

/datum/reagent/polonium
	name = "Polonium"
	id = "polonium"
	description = "+8 RAD."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.1

/datum/reagent/polonium/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.radiation += 8
	..()
	return


/datum/reagent/histamine
	name = "Histamine"
	id = "histamine"
	description = "A dose-dependent toxin, ranges from annoying to incredibly lethal."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.2
	overdose_threshold = 30

/datum/reagent/histamine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	switch(pick(1, 2, 3, 4))
		if(1)
			M << "<span class='danger'>You can barely see!</span>"
			M.eye_blurry = 3
		if(2)
			M.emote("cough")
		if(3)
			M.emote("sneeze")
		if(4)
			if(prob(75))
				M << "You scratch at an itch."
				M.adjustBruteLoss(2*REM)
	..()
	return
/datum/reagent/histamine/overdose_process(var/mob/living/M as mob)
	M.adjustOxyLoss(pick(1,3)*REM)
	M.adjustBruteLoss(pick(1,3)*REM)
	M.adjustToxLoss(pick(1,3)*REM)
	..()
	return

/datum/reagent/formaldehyde
	name = "Formaldehyde"
	id = "formaldehyde"
	description = "+1 TOX, 10% chance to decay into 5-15 units of histamine."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0

/datum/reagent/formaldehyde/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss(1*REM)
	if(prob(10))
		M.reagents.add_reagent("histamine",pick(5,15))
		M.reagents.remove_reagent("formaldehyde",1)
	..()
	return

/datum/chemical_reaction/formaldehyde
	name = "formaldehyde"
	id = "Formaldehyde"
	required_reagents = list("ethanol" = 1, "oxygen" = 1, "silver" = 1)
	min_temperature = 420
	results = list("formaldehyde" = 3)

/datum/reagent/venom
	name = "Venom"
	id = "venom"
	description = "Scaling TOX and BRUTE damage with dose. 25% chance to decay into 5-10 histamine."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.2
/datum/reagent/venom/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss((0.1*volume)*REM)
	M.adjustBruteLoss((0.1*volume)*REM)
	if(prob(25))
		M.reagents.add_reagent("histamine",pick(5,10))
		M.reagents.remove_reagent("venom",1)
	..()
	return

/datum/reagent/neurotoxin2
	name = "Neurotoxin"
	id = "neurotoxin2"
	description = "+1 TOX, +1 BRAIN up to 60 before it slows down, confusion, knockout after 17 elapsed cycles."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	var/cycle_count = 0
	custom_metabolism = 1

/datum/reagent/neurotoxin2/on_mob_life(var/mob/living/M as mob)
	cycle_count++
	if(M.brainloss + M.toxloss <= 60)
		M.adjustBrainLoss(1*REM)
		M.adjustToxLoss(1*REM)
	if(cycle_count == 17)
		M.sleeping += 10 // buffed so it works
	..()
	return

/datum/chemical_reaction/neurotoxin2
	name = "neurotoxin2"
	id = "neurotoxin2"
	required_reagents = list("space_drugs" = 1)
	min_temperature = 200
	results = list("neurotoxin2" = 1)

/datum/reagent/cyanide
	name = "Cyanide"
	id = "cyanide"
	description = "+1.5 TOX, 10% chance of +1 LOSEBREATH, 8% chance of stun and extra +2 TOX."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.1

/datum/reagent/cyanide/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss(1.5*REM)
	if(prob(10))
		M.losebreath += 1
	if(prob(8))
		M << "You feel horrendously weak!"
		M.Stun(2)
		M.Weaken(2)
		M.adjustToxLoss(2*REM)
	..()
	return

/datum/chemical_reaction/cyanide
	name = "Cyanide"
	id = "cyanide"
	required_reagents = list("oil" = 1, "ammonia" = 1, "oxygen" = 1)
	min_temperature = 380
	results = list("cyanide" = 3)

/datum/reagent/questionmark
	name = "Bad Food"
	id = "????"
	description = "????"
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.2

/datum/reagent/questionmark/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss(1*REM)
	..()
	return

/datum/reagent/itching_powder
	name = "Itching Powder"
	id = "itching_powder"
	description = "Lots of annoying random effects, chances to do BRUTE damage from scratching. 6% chance to decay into 1-3 units of histamine."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.3

/datum/reagent/itching_powder/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	if(method == TOUCH)
		M.reagents.add_reagent("itching_powder", volume)
		return

/datum/reagent/itching_powder/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(rand(5,50)))
		M << "You scratch at your head."
		M.visible_message("<span class = 'notice'>[M] scratches their head.</span>")
		M.adjustBruteLoss(0.2*REM)
	else if(prob(rand(5,50)))
		M << "You scratch at your leg."
		M.visible_message("<span class = 'notice'>[M] scratches their leg.</span>")
		M.adjustBruteLoss(0.2*REM)
	else if(prob(rand(5,50)))
		M << "You scratch at your arm."
		M.visible_message("<span class = 'notice'>[M] scratches their arm.</span>")
		M.adjustBruteLoss(0.2*REM)
	if(prob(6))
		M.reagents.add_reagent("histamine",rand(1,3))
		M.reagents.remove_reagent("itching_powder",1)
	..()
	return

/datum/chemical_reaction/itching_powder
	name = "Itching Powder"
	id = "itching_powder"
	required_reagents = list("fuel" = 1, "ammonia" = 1, "charcoal" = 1)
	results = list("itching_powder" = 3)

/datum/reagent/cholesterol
	name = "Cholesterol"
	id = "cholesterol"
	description = "Minor stamina penalty."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0]
	overdose_threshold = 25

/datum/reagent/cholesterol/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss(0.2)
	..()
	return

/datum/reagent/cholesterol/overdose_process(var/mob/living/M as mob)
	if(prob(rand(1,100)))
		M.adjustToxLoss(1)
	if(prob(rand(1,100)))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
			M.show_message("You fumble and drop [I]!")
	if(prob(rand(1,100)))
		M.Stun(1)
	..()
	return

/datum/reagent/porktonium
	name = "Porktonium"
	id = "porktonium"
	description = "OVERDOSE - An 8% chance of metabolizing to 10 cyanide, 15 radium and 2 cholesterol for every 0.2 units above 125."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0]
	overdose_threshold = 125
	custom_metabolism = 0.2

/datum/reagent/porktonium/overdose_process(var/mob/living/M as mob)
	if(prob(8) && volume > 125)
		M.reagents.add_reagent("cyanide", 10)
		M.reagents.add_reagent("radium", 15)
		M.reagents.add_reagent("cholesterol", 2)
		M.reagents.remove_reagent("corn_syrup", 0.2)
	..()
	return

/obj/item/weapon/reagent_containers/glass/bottle/polonium
	name = "polonium bottle"
	desc = "A small bottle. Contains Polonium."
	icon_state = "bottle16"

/obj/item/weapon/reagent_containers/glass/bottle/polonium/New()
	..()
	reagents.add_reagent("polonium", 60)

/obj/item/weapon/reagent_containers/glass/bottle/venom
	name = "venom bottle"
	desc = "A small bottle. Contains Venom."
	icon_state = "bottle16"

/obj/item/weapon/reagent_containers/glass/bottle/venom/New()
	..()
	reagents.add_reagent("venom", 60)

/obj/item/weapon/reagent_containers/glass/bottle/neurotoxin2
	name = "neurotoxin bottle"
	desc = "A small bottle. Contains Neurotoxin."
	icon_state = "bottle16"

/obj/item/weapon/reagent_containers/glass/bottle/neurotoxin2/New()
	..()
	reagents.add_reagent("neurotoxin2", 60)

/obj/item/weapon/reagent_containers/glass/bottle/formaldehyde
	name = "formaldehyde bottle"
	desc = "A small bottle. Contains Formaldehyde."
	icon_state = "bottle16"

/obj/item/weapon/reagent_containers/glass/bottle/formaldehyde/New()
	..()
	reagents.add_reagent("formaldehyde", 60)

/obj/item/weapon/reagent_containers/glass/bottle/histamine
	name = "histamine bottle"
	desc = "A small bottle. Contains Histamine."
	icon_state = "bottle16"

/obj/item/weapon/reagent_containers/glass/bottle/histamine/New()
	..()
	reagents.add_reagent("histamine", 60)
