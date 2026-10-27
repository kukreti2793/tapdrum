import Darwin
import Foundation
import TapDrumCore

struct ResourceReadout {
    var cpuPercent: Double?
    var footprintMiB: Double?
    var thermalState = "Unknown"
}

struct ResourceSampler {
    private var cpu = CPUUsageSampler()

    mutating func sample() -> ResourceReadout {
        var result = ResourceReadout()
        var usage = rusage()
        if getrusage(RUSAGE_SELF, &usage) == 0 {
            let cpuSeconds = Double(usage.ru_utime.tv_sec + usage.ru_stime.tv_sec)
                + Double(usage.ru_utime.tv_usec + usage.ru_stime.tv_usec) / 1_000_000
            result.cpuPercent = cpu.sample(cpuSeconds: cpuSeconds, hostSeconds: HostTime.seconds)
        }
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
        let status = withUnsafeMutablePointer(to: &info) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        if status == KERN_SUCCESS { result.footprintMiB = Double(info.phys_footprint) / 1_048_576 }
        switch ProcessInfo.processInfo.thermalState {
        case .nominal: result.thermalState = "Nominal"
        case .fair: result.thermalState = "Fair"
        case .serious: result.thermalState = "Serious"
        case .critical: result.thermalState = "Critical"
        @unknown default: result.thermalState = "Unknown"
        }
        return result
    }
}
