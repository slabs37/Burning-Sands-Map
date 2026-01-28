import * as rm from "https://deno.land/x/remapper@4.2.0/src/mod.ts"
import * as bundleInfo from '../bundleinfo.json' with { type: 'json' }

const pipeline = await rm.createPipeline({ bundleInfo })

const bundle = rm.loadBundle(bundleInfo)
const materials = bundle.materials
const prefabs = bundle.prefabs

// ----------- { SCRIPT } -----------

async function doMap(file: rm.DIFFICULTY_NAME) {
    const map = await rm.readDifficultyV3(pipeline, file)
    map.difficultyInfo.requirements = [
        'Chroma',
        'Noodle Extensions',
        'Vivify',
    ]
    rm.environmentRemoval(map, ['Environment', 'GameCore'])

    map.difficultyInfo.settingsSetter = {
        graphics: {
            screenDisplacementEffectsEnabled: true,
        },
        chroma: {
            disableEnvironmentEnhancements: false,
        },
        playerOptions: {
            leftHanded: rm.BOOLEAN.False,
            noteJumpDurationTypeSettings: 'Dynamic',
        },
        colors: {},
        environments: {},
    }

    rm.setRenderingSettings(map, {
        qualitySettings: {
            realtimeReflectionProbes: rm.BOOLEAN.True,
            shadows: rm.SHADOWS.HardOnly,
            shadowDistance: 64,
            shadowResolution: rm.SHADOW_RESOLUTION.VeryHigh,
            
        },
        renderSettings: {
            fog: rm.BOOLEAN.True,
            fogEndDistance: 64,
        },
    })

    const sc1 = prefabs.scene1.instantiate(map, 0)
    const sc2 = prefabs.scene2.instantiate(map, 0)
    const sc3 = prefabs.scene3.instantiate(map, 0)
    const sc4 = prefabs.scene4.instantiate(map, 0)

    // note changes
    // --------------------------------------------------
    rm.assignObjectPrefab(map, {
        colorNotes: {
            track: 'MainNotes',
            asset: prefabs['custom note'].path,
            debrisAsset: prefabs['custom note debris'].path,
            anyDirectionAsset: prefabs['custom note dot'].path
        }
    })

    // saber changes
    // --------------------------------------------------
    rm.assignObjectPrefab(map, {
        saber: {
            beat: 0,
            type: 'Left',
            asset: prefabs.leftsaberb.path,
            trailAsset: prefabs.sabertrail.path,
            trailDuration: 0.15
        }
    })
    rm.assignObjectPrefab(map, {
        saber: {
            beat: 0,
            type: 'Right',
            asset: prefabs.rightsaberb.path,
            trailAsset: prefabs.sabertrail.path,
            trailDuration: 0.15
        }
    })
    rm.assignObjectPrefab(map, {
        beat : 149,
        saber: {
            type: 'Left',
            asset: prefabs.leftsaber1.path,
            trailAsset: prefabs.sabertrail.path,
            trailDuration: 0.15
        },
    })
    rm.assignObjectPrefab(map, {
        beat : 149,
        saber: {
            type: 'Right',
            asset: prefabs.rightsaber1.path,
            trailAsset: prefabs.sabertrail.path,
            trailDuration: 0.15
        },
    })

    rm.assignObjectPrefab(map, {
        beat : 271,
        saber: {
            type: 'Left',
            asset: prefabs.leftsaberb.path,
            trailAsset: prefabs.sabertrail.path,
            trailDuration: 0.15
        },
    })
    rm.assignObjectPrefab(map, {
        beat : 271,
        saber: {
            type: 'Right',
            asset: prefabs.rightsaberb.path,
            trailAsset: prefabs.sabertrail.path,
            trailDuration: 0.15
        },
    })
    
    rm.assignObjectPrefab(map, {
        beat : 425,
        saber: {
            type: 'Left',
            asset: prefabs.leftsaber1.path,
            trailAsset: prefabs.sabertrail.path,
            trailDuration: 0.15
        },
    })

    rm.assignObjectPrefab(map, {
        beat : 425,
        saber: {
            type: 'Right',
            asset: prefabs.rightsaber1.path,
            trailAsset: prefabs.sabertrail.path,
            trailDuration: 0.15
        },
    })

    // note tracks
    // --------------------------------------------------
    rm.assignPathAnimation(map, {
        track: 'Sc1-1',
        animation: {
            offsetPosition: [
                [0, 2, 0, 0],
                [0, 2, 0, 0.3],
                [0, 0, 0, 0.4, "easeOutSine"],
            ],
            dissolve: [
                [0, 0],
                [1, 0.1]
            ]
        },
    })

    rm.assignPathAnimation(map, {
        track: 'Sc3-1',
        animation: {
            dissolve: [
                [0, 0],
                [0, 0.1],
                [0.5, 0.15],
                [1, 0.4]
            ],
             dissolveArrow: [
                [0, 0],
                [0, 0.01],
                [0.5, 0.15],
                [1, 0.4]
            ]
        },
    })
    rm.assignPathAnimation(map, {
        track: 'Sc3-2',
        animation: {
            offsetPosition: [
                [0,0,-50,0, "easeOutQuad"],
                [0,0,-11,0.09, "easeInOutSine"],
                [0,0,0,0.35],
                [0,0,-1,0.6]
            ],
            dissolve: [
                [0, 0],
                [0, 0.1],
                [0.5, 0.15],
                [1, 0.4]
            ],
             dissolveArrow: [
                [0, 0],
                [0, 0.1],
                [0.5, 0.15],
                [1, 0.4]
            ]
        },
    })
    rm.assignPathAnimation(map, {
        beat: 335,
        track: 'Sc4-1',
        duration: 8,
        animation: {
            offsetPosition: [
                [0, 0, 0, 0],
                [0, 0.5, 0, 0.6],
            ]
        },
    })
    rm.assignPathAnimation(map, {
        track: 'Sc4-2',
        animation: {
            offsetPosition: [
                [0, 0.5, 0, 0],
                [0, 0, 0, 0.6],
            ]
        },
    })

    // --------------------------------------------------
    map.colorNotes.forEach(note => {
        note.track.add('MainNotes')
        note.unsafeCustomData._disableSpawnEffect = rm.BOOLEAN.False
        //sc1
        if (note.beat >= 0 && note.beat <= 38) {
            note.track.add('Sc1-1')
            note.noteJumpMovementSpeed = 10
        }
        if (note.beat >= 39 && note.beat <= 70) {
            note.noteJumpMovementSpeed = 15
        }
        //sc3
        //271 - 286 space
        //287 - 302 ship
        //302 - 334 above
        if (note.beat >= 271 && note.beat <= 286) {
            note.track.add('Sc3-1')
            note.noteJumpMovementSpeed = 10
        }
        if (note.beat >= 287 && note.beat <= 302) {
            note.track.add('Sc3-2')
            note.noteJumpMovementSpeed = 10
        }
        if (note.beat >= 303 && note.beat <= 334) {
            note.noteJumpMovementSpeed = 15
        }
        //sc4
        //335 - 342 slowly up, is bad
        /*
        if (note.beat >= 335 && note.beat <= 342) {
            note.track.add('Sc4-1')
        }
        //342 - 510 big ship, NOPE
        if (note.beat >= 342 && note.beat <= 510) {
            note.track.add('Sc4-2')
        }
            */
    })

    /*note.color 1 is right hand, 0 is left hand
            if (note.color) {
                note.track.add('Sc1-1')
            } else {
                note.track.add('Sc1-1')
            }
    */

    // Example: Run code on every note!

    // map.allNotes.forEach(note => {
    //     console.log(note.beat)
    // })

    // For more help, read: https://github.com/Swifter1243/ReMapper/wiki
    // I CAN'T GOD DAMNIT I HAVE NO INTERNET IRAN HAS CUT US OFF - 1/12/2026
}

await Promise.all([
    doMap('ExpertPlusStandard')
])

// ----------- { OUTPUT } -----------

pipeline.export({
    outputDirectory: '../Burning Sans'
})

// deno run --allow-all src/main.ts