/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import { CMModelErrorCode } from '../model/CertMangerModel';

const TAG = 'certManager BUNDLE:';

export class BundleNameModel {
  async getAppInfoList(appUid, callback): Promise<void> {
    console.log(TAG + 'getAppInfoList enter uid: ' + appUid);
    try {
      let appInfo = {
        appImage: '',
        appName: '',
      };

      let appBundleName = await bundleManager.getBundleNameByUid(appUid);
      console.log(TAG + 'appBundleName: ' + appBundleName);

      let bundleContext = globalThis.certManagerAbilityContext.createBundleContext(appBundleName);
      let info = await bundleManager.getBundleInfo(appBundleName,
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      console.log(TAG + 'appName: ' + appBundleName + ', iconId: ' + info.appInfo.iconId +
        ', labelId: ' + info.appInfo.labelId);

      appInfo.appName = await bundleContext.resourceManager.getStringValue(info.appInfo.labelId);
      appInfo.appImage = await bundleContext.resourceManager.getMediaContentBase64(info.appInfo.iconId);
      console.log(TAG + 'get bundle info success');

      callback(CMModelErrorCode.CM_MODEL_ERROR_SUCCESS, appInfo);
    } catch (err) {
      console.error(TAG + 'getAppInfoList failed', JSON.stringify(err.code));
      callback(CMModelErrorCode.CM_MODEL_ERROR_EXCEPTION, null);
    }
  }
}

let bundleNameModel = new BundleNameModel();

export default bundleNameModel as BundleNameModel;
