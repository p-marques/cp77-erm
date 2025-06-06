module ERM.Settings

public class Menu extends ERMSettings {
    @runtimeProperty("ModSettings.mod", "Eddies Received Mult")
    @runtimeProperty("ModSettings.category", "Main")
    @runtimeProperty("ModSettings.displayName", "Enabled")
    @runtimeProperty("ModSettings.description", "Enable/Disable mod.")
    public let IsEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "Eddies Received Mult")
    @runtimeProperty("ModSettings.category", "Main")
    @runtimeProperty("ModSettings.displayName", "Multiplier")
    @runtimeProperty("ModSettings.description", "Eddies received will be multiplied by this value.")
    @runtimeProperty("ModSettings.step", "0.1")
    @runtimeProperty("ModSettings.min", "0.1")
    @runtimeProperty("ModSettings.max", "5.0")
    public let EddiesMultiplier: Float = 1.0;

    @runtimeProperty("ModSettings.mod", "Eddies Received Mult")
    @runtimeProperty("ModSettings.category", "Extra")
    @runtimeProperty("ModSettings.displayName", "Show Extra Eddies Msg")
    @runtimeProperty("ModSettings.description", "Enable/Disable the showing of an extra eddies received activity log notification.")
    public let ShowExtraEddiesMsg: Bool = false;

    public func Setup() -> Void {
        RegisterMenu(this);
    }

    public func GetIsEnabled() -> Bool {
        return this.IsEnabled;
    }

    public func GetMultiplier() -> Float {
        return this.EddiesMultiplier;
    }

    public func GetShowExtraEddiesMsg() -> Bool {
        return this.ShowExtraEddiesMsg;
    }
}

@if(!ModuleExists("ModSettingsModule"))
public func RegisterMenu(listener: ref<IScriptable>) {}

@if(ModuleExists("ModSettingsModule"))
public func RegisterMenu(listener: ref<IScriptable>) {
    ModSettings.RegisterListenerToClass(listener);
}