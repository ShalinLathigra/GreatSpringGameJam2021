# GreatSummerGameJam2021
Theme: Spring, Optional Mechanic: Constant Growth.


Core ideas:
    Mechanics light, want to focus on nailing the Spring vibe.
    
    Basic idea is that you're a squirrel trying to find a bunch of nuts scattered around the park.
    Gonna feature some pretty basic platforming about a static area.
        Need to be able to clamber around, climb/jump off of trees
        Need to REALLY clinch the movement
    
    Total there will be three levels:
        Small squirrel (collect 3 nuts)
        medium squirrel (collect 5 nuts)
        Big Squirrel (collect 10 nuts)

    Each level will indicate a different portion of Spring and will be accompanied by visible changes in the level.
        Tree Trunks will go from 0 -> 0 marbled with 1 -> 1 marbled with 6
        Tree Leaves will go from 1/5 -> 5/4 -> 4/3
            By default, can climb on all tree surfaces.
            As levels increase, trees will grow new limbs/bigger tufts of leaves to allow for easier movement.
                * Level Design:
                    Level 0 should reveal paths that can be crossed in Level 1, same for Level 1 and 2
                    Should also include a marker system to show what Acorns currently exist

        Squirrel and Nuts will be 7/3/2/0 probably

    Gonna use a palette swap shader to control colour changes
        takes in the index for black and index for white.
        Shader code just needs to determine what colour to use with step, then interp between texSample at those indices
    Gonna have a Two main scenes:
        Home/Outside.
    
        Home will be a small area where you can just climb around the floor/walls/etc. Just for fun.
            Maybe toss in a chandelier to jump on/mess with lol
        Outside will be a large-ish platforming level, certain areas will be inaccessible until later levels as mentioned above
            Jump dist, speed, and stuff should also increase as levels increase.

            Also should have a really crunchy enemy to deal with.

        Should also include a scene transition from level 0 to level 1?
            Overnight, Tone level towards blue, change background to night, palette shift to day, shift level back to white


Need to figure out Slopes!!!

Info on Player Movement is in Squirrel.gd