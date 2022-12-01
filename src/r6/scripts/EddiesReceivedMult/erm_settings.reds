module ERM.Settings

public class ERMSettings {
    private let multiplier: Float;
    private let showExtraEddiesMsg: Bool;

    public func Setup() -> Void {
        // ------ Settings Start ------

        // Eddies received will be multiplied by this value. Default = 1.0
        this.multiplier = 1.0;

        // Show an extra eddies received activity log notification. Default = false
        this.showExtraEddiesMsg = false;

        // ------ Settings End ------
    }

    public func GetMultiplier() -> Float {
        return this.multiplier;
    }

    public func GetIsEnabled() -> Bool {
        return true;
    }

    public func GetShowExtraEddiesMsg() -> Bool {
        return this.showExtraEddiesMsg;
    }
}