/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { GlobalContext, PwdStore } from '../common/GlobalContext';
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';

export default class MainExtensionAbility extends UIExtensionAbility {
  onCreate(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'MainExtensionAbility onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'UIExtensionAbility onDestroy');
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'MainExtensionAbility onSessionCreate');
    let param: Record<string, Object> = {
      'session': session
    }
    let storage: LocalStorage = new LocalStorage(param);
    session.loadContent('pages/certManagerFa', storage);
    GlobalContext.getContext().setAbilityWant(want);
    GlobalContext.getContext().setSession(session);
    let pwdStore = new PwdStore();
    GlobalContext.getContext().setPwdStore(pwdStore);
    GlobalContext.getContext().setFlag(true);
  }

  onSessionDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'MainExtensionAbility onSessionDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'MainExtensionAbility onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'MainExtensionAbility onBackground');
  }
}
