Config = {

    framework = "ESX",

    death = {
        mode = "default", --[[ "default" or "event"
            - when using deafult will automatically check when the player is considered dead (vanilla style)
            - when using event the script will wait for the event you specified to make any calculation
        ]]
        event = "event:name"
    },

    discordBot = {
    }
}