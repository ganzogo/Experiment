import Commander
import ExperimentCore
import Foundation

guard let experimentsPath = ProcessInfo.processInfo.environment["EXPERIMENTS_PATH"] else {
    fatalError("EXPERIMENTS_PATH is not set")
}

let main = command(
    Argument<String?>("name", description: "The name of your new experiment")
) { name in

    do {
        let experiment = try Experiment(path: experimentsPath, name: name)
        try experiment.generate()
    } catch {
        FileHandle.standardError.write("\(error.localizedDescription)\n")
    }
}

main.run()
