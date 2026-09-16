/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import bundleManager from '@ohos.bundle.bundleManager';
import Want from '@ohos.app.ability.Want';
import Logger from './Logger';

const USER_ID = 100;
const TAG = 'BundleInfoModel';
const ACTION = 'action.access.privacy.center';

class BundleInfoModel {

  async queryExtensionAbilityInfoOther() {
    Logger.info(TAG, 'queryExtensionAbilityInfoOther');
    let extensionAbilityType = bundleManager.ExtensionAbilityType.UNSPECIFIED;
    let extensionFlags = bundleManager.ExtensionAbilityFlag.GET_EXTENSION_ABILITY_INFO_WITH_METADATA |
    bundleManager.ExtensionAbilityFlag.GET_EXTENSION_ABILITY_INFO_WITH_APPLICATION;
    let userId = USER_ID;
    let want: Want = {
      action: ACTION,
    };
    let result: bundleManager.ExtensionAbilityInfo[] = [];
    try {
      result = await bundleManager.queryExtensionAbilityInfo(want, extensionAbilityType, extensionFlags, userId)
    } catch (err) {
      Logger.error(TAG, `queryExtensionAbilityInfoOther fail: ${JSON.stringify(err)}`);
    }
    return result;
  }

  async queryAbilityInfoOther() {
    Logger.info(TAG, 'queryAbilityInfoOther');
    let extensionFlags = bundleManager.ExtensionAbilityFlag.GET_EXTENSION_ABILITY_INFO_WITH_METADATA |
    bundleManager.ExtensionAbilityFlag.GET_EXTENSION_ABILITY_INFO_WITH_APPLICATION;
    let userId = USER_ID;
    let want: Want = {
      action: ACTION,
    };
    let result: bundleManager.AbilityInfo[] = [];
    try {
      result = await bundleManager.queryAbilityInfo(want, extensionFlags, userId)
    } catch (err) {
      Logger.error(TAG, `queryExtensionAbilityInfoOther fail: ${JSON.stringify(err)}`);
    }
    return result;
  }

  //   Get all application information about feature access
  getAllBundleInfoByFunctionAccess() {
    let modelFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
    return new Promise<bundleManager.BundleInfo[]>((resolve) => {
      bundleManager.getAllBundleInfo(modelFlags).then((data) => {
        resolve(data)
      }).catch((error: Error) => {
        resolve([])
        Logger.error(TAG, `getAllBundleInfo error: ${JSON.stringify(error)}`)
      })
    })
  }
}

let bundleInfoModel = new BundleInfoModel();

export default bundleInfoModel as BundleInfoModel;
