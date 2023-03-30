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

import Ability from '@ohos.app.ability.UIAbility';

class PwdStore {
  private certPwd: string = '';
  setCertPwd(pwd): void {
    this.certPwd = pwd;
  }

  getCertPwd(): string {
    return this.certPwd;
  }

  clearCertPwd(): void {
    this.certPwd = '';
  }
}

export default class MainAbility extends Ability {
  onCreate(want, launchParam): void {
    console.log('[Demo] MainAbility onCreate');
    globalThis.certManagerAbilityContext = this.context;
    globalThis.PwdStore = new PwdStore();
    globalThis.abilityWant = want;
    globalThis.abilityContext = this.context;
  }

  onDestroy(): void {
    console.log('[Demo] MainAbility onDestroy');
  }

  onWindowStageCreate(windowStage): void {
    // Main window is created, set main page for this ability
    console.log('[Demo] MainAbility onWindowStageCreate');
    windowStage.setUIContent(this.context, 'pages/certManagerFa', null);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    console.log('[Demo] MainAbility onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    console.log('[Demo] MainAbility onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    console.log('[Demo] MainAbility onBackground');
  }

  onNewWant(want): void {
    console.log('[Demo] MainAbility onNewWant');
    globalThis.abilityWant = want;
  }
};
