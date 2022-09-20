/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Ability from '@ohos.application.Ability';
import certManager from '../stub/certStubPromise'

class PwdStore {
    private certPwd: string = '';
    setCertPwd(pwd) {
        this.certPwd = pwd;
    }

    getCertPwd() {
        return this.certPwd;
    }

    clearCertPwd() {
        this.certPwd = '';
    }
}

export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        console.log("[Demo] MainAbility onCreate")
        globalThis.certManagerAbilityContext = this.context
        globalThis.PwdStore = new PwdStore();
        globalThis.abilityWant = want;
        globalThis.certStub = certManager;
        globalThis.certStub.restoreAllMaps();
    }

    onDestroy() {
        console.log("[Demo] MainAbility onDestroy")
        globalThis.certStub.saveAllMaps();
    }

    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        console.log("[Demo] MainAbility onWindowStageCreate")
        windowStage.setUIContent(this.context, "pages/certManagerFa", null)
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        console.log("[Demo] MainAbility onWindowStageDestroy")
    }

    onForeground() {
        // Ability has brought to foreground
        console.log("[Demo] MainAbility onForeground")
    }

    onBackground() {
        // Ability has back to background
        console.log("[Demo] MainAbility onBackground")
    }

    onNewWant(want) {
        console.log("[Demo] MainAbility onNewWant")
        globalThis.abilityWant = want;
    }
};
