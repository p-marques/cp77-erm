module ERM.Base
import ERM.Settings.ERMSettings
import ERM.Settings.Menu

public class ERMSystem extends ScriptableSystem {
    private let player: ref<PlayerPuppet>;
    private let transactionSystem: ref<TransactionSystem>;
    private let ermCallback: ref<ERMCallback>;
    private let inventoryListener: ref<InventoryScriptListener>;
    private let lastRequestHandled: Bool;
    private let settings: ref<ERMSettings>;

    private func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
        this.player = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
        this.transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());

        this.ermCallback = new ERMCallback();
        this.ermCallback.ermSys = this;
        this.inventoryListener = this.transactionSystem.RegisterInventoryListener(this.player, this.ermCallback);

        this.settings = GetSettings();
        this.settings.Setup();
    }

    private func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
        this.transactionSystem.UnregisterInventoryListener(this.player, this.inventoryListener);
        this.inventoryListener = null;
    }

    public func OnEddiesChanged(request: ref<ERMHandleEddiesChangedRequest>) -> Void {
        let delta: Int32;
        let multiplier: Float;

        if !this.settings.GetIsEnabled() {
            return;
        }

        if request.diffAmount < 1 {
            return;
        }

        if !this.lastRequestHandled {
            multiplier = this.settings.GetMultiplier();

            if multiplier < 0.1 {
                multiplier = 1.0;
            }

            if Equals(multiplier, 1.0) {
                return;
            }

            delta = Cast<Int32>(Cast<Float>(request.diffAmount) * multiplier) - request.diffAmount;

            if delta > 0 {
                this.transactionSystem.GiveItem(this.player, MarketSystem.Money(), delta);
            }
            else {
                this.transactionSystem.RemoveItem(this.player, MarketSystem.Money(), -delta);
            }

            if this.settings.GetShowExtraEddiesMsg() {
                GameInstance.GetActivityLogSystem(this.GetGameInstance()).AddLog("[ERM] Received " + delta + " extra eddies.");
            }

            this.lastRequestHandled = true;
        }
        else {
            this.lastRequestHandled = false;
        }
    }
}

public class ERMCallback extends InventoryScriptCallback {
    public let ermSys: ref<ERMSystem>;

    public func OnItemQuantityChanged(item: ItemID, diff: Int32, total: Uint32, flaggedAsSilent: Bool) -> Void {
        let request: ref<ERMHandleEddiesChangedRequest>;

        if Equals(MarketSystem.Money(), item) {
            if IsDefined(this.ermSys) {
                request = new ERMHandleEddiesChangedRequest();
                request.diffAmount = diff;

                this.ermSys.QueueRequest(request);
            }
        }
    }
}

public class ERMHandleEddiesChangedRequest extends ScriptableSystemRequest {
    public let diffAmount: Int32;
}

@if(!ModuleExists("ModSettingsModule"))
public func GetSettings() -> ref<ERMSettings> {
    return new ERMSettings();
}

@if(ModuleExists("ModSettingsModule"))
public func GetSettings() -> ref<ERMSettings> {
    return new Menu();
}