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

import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { GlobalContext, PwdStore } from '../common/GlobalContext';
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';

export default class CertPickerUiExtAbility extends UIExtensionAbility {
  onCreate(): void {
    console.info('[CertManager] CertPickerUiExtAbility onCreate');
  }

  onDestroy(): void {
    console.info('[CertManager] CertPickerUiExtAbility onDestroy');
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    console.info('[CertManager] CertPickerUiExtAbility onSessionCreate');

    if (want === null || want === undefined) {
      console.error('[CertManager] invalid want param');
      return;
    }
    let param: Record<string, Object> = {
      'session': session,
      'want': want
    }
    let storage: LocalStorage = new LocalStorage(param);
    session.loadContent('pages/picker/CertManagerSheetFa', storage);
    let pwdStore = new PwdStore();
    GlobalContext.getContext().setPwdStore(pwdStore);
    try {
      session.setWindowBackgroundColor('#00000000');
    } catch (err) {
      console.error('[CertManager] CertPickerUiExtAbility setWindowBackgroundColor');
    }
  }

  onSessionDestroy(): void {
    // Main window is destroyed, release UI related resources
    GlobalContext.getContext().clearSession();
    console.info('[CertManager] CertPickerUiExtAbility onSessionDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    console.info('[CertManager] CertPickerUiExtAbility onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    console.info('[CertManager] CertPickerUiExtAbility onBackground');
  }
}
