local Translations = {
    npc = {
        cooldown = 'We dont want you to work here now!',
        alreadystarted = 'You have already started the run!',
        nocops = 'There is not enough cops on duty!',
        sendername = 'Unknown',
        sendersubject = 'Oxydelivery',
        sendermessage = 'Hey, you want to work for me? Okay, Find a vehicle with a trunk. I will send you a message when you are at the vehicle. Oh, and bring some marked cash if you have any, You will be awarded well!',
        sendermessage2 = 'Hey, I sended the GPS-location to the supplier. Take the packages and send them to the dropoff point!',
        target = 'Sign in',
        targeticon = 'fa-solid fa-user-secret',
        progressbartext = 'Speaking with the boss...'
    },
    npc2 = {
        toomanypackages = 'You already took too many packages!',
        notinrun = 'Get out. I only serve people that knows my boss!',
        drivetohandoff = 'Drive to the handoff location with the vehicle!',
        inlocation = 'You are at the location, wait for customers!',
        getbackinlocation = 'Go back to the handoff location!',
        putintrunk = 'Put your package in the trunk then ask for more',
        target = 'Grab package',
        targeticon = 'fa-solid fa-user-secret'
    },
    npc3 = {
     target = "Sell Oxy",
     targeticon = "fa-solid fa-prescription-bottle-medical",
     nooxy = "No oxy to sell for me!"
    },
    handoff = {
        h1 = 'Well done, (1/5)',
        h2 = 'Well done, (2/5)',
        h3 = 'Well done, (3/5)',
        h4 = 'Well done, (4/5)',
        h5 = 'Well done, (5/5)',
        done = 'Done for now, thanks!',
        noitem = 'No package in inventory!',
        message = 'Hey, you seemed to work well, thank you! I will be disponible soon again.',
        target = 'Handoff package'
    },
}



Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})