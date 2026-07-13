/**
 * Copyright (c) 2026-2026 Huawei Device Co., Ltd.
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
import { window } from '@kit.ArkUI';
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Logger from '../common/utils/Logger';
import { GlobalContext } from '../common/utils/GlobalContext';
import RouterConstant from '../common/constants/RouterConstant';


const TAG: string = 'UIExtSettingAbility :';

export default class UIExtSettingAbility extends UIExtensionAbility {
  async onCreate(): Promise<void> {
    Logger.info(TAG, 'onCreate')
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    try {
      const extensionWindow = session.getUIExtensionWindowProxy();
      const area = extensionWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      const statusBarHeight = px2vp(area.topRect.height)
      AppStorage.setOrCreate('STATUS_BAR_HEIGHT', statusBarHeight)
      GlobalContext.getContext().setSession(session)
      const targetSubRouter = want.parameters?.targetSubRouter
      if (targetSubRouter) {
        if (targetSubRouter === 'location_manager_settings') {
          session.loadContent(RouterConstant.LOCATION_PAGE_URL)
        } else {
          session.loadContent(RouterConstant.INDEX_URL)
        }
      } else {
        session.loadContent(RouterConstant.INDEX_URL)
      }
    } catch (error) {
      Logger.error(TAG, 'onSessionCreate error.code:' + error?.code + ' error.message:' + error?.message)
    }
  }

  onSessionDestroy(): void {
    Logger.info(TAG, 'onSessionDestroy')
  }

  onDestroy(): void {
    Logger.info(TAG, 'onDestroy')
  }
}