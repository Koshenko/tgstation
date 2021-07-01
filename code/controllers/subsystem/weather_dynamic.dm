SUBSYSTEM_DEF(weather_dynamic)
	name = "Weather Dynamic"
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/atom/movable/weather/weather_source_object = new()

/atom/movable/weather
	name = ""
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "light_ash"
	move_resist = INFINITY
	plane = BLACKNESS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/weather/Initialize(mapload)
	. = ..()
	var/list/affected_z_levels = SSmapping.levels_by_trait(ZTRAIT_SNOWSTORM)
	//to_chat(world, "<span class='boldannounce'>[affected_z_levels[1]]</span>")
	//log_world(affected_z_levels[1])

/datum/component/weather_origin
	var/list/turfs_below
	var/turf/roof

/datum/component/weather_origin/Initialize(mapload)
	if(!isturf(parent))
		return COMPONENT_INCOMPATIBLE
	LAZYINITLIST(turfs_below)
	var/turf/curr_turf = parent
	while(curr_turf.below())
		turfs_below += curr_turf.below()
		curr_turf = curr_turf.below()
	find_roof()

/datum/component/weather_origin/proc/find_roof()
	var/turf/parent_turf = parent
	parent_turf.vis_contents += SSweather_dynamic.weather_source_object
	for(var/turf/specific_turf as anything in turfs_below)
		if(!isopenspaceturf(specific_turf))
			roof = specific_turf
			break
		else
			specific_turf.vis_contents += SSweather_dynamic.weather_source_object
