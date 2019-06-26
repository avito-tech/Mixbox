import BuildDsl
import StaticChecksTask

BuildDsl.teamcity.main { di in
    StaticChecksTask()
}

