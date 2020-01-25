import ExperimentCore

do {
    let experiment = Experiment()
    try experiment.run()
} catch {
    print(error)
}
