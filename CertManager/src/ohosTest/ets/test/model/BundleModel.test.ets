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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { AppInfoVo } from '../../../../main/ets/model/CertManagerVo/AppInfoVo';
import { CMModelErrorCode } from '../../../../main/ets/model/CertMangerModel';
import bundleModel from '../../../../main/ets/model/BundleModel';

export default function BundleNameModelTest() {
  describe('BundleNameModelTest', () => {
    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it("getAppInfoListTest", 0, () => {
      const appUid = 20020058;
      let errCode: CMModelErrorCode = CMModelErrorCode.CM_MODEL_ERROR_SUCCESS;
      let appInfoRet: AppInfoVo = {
        appImage: '',
        appName: ''
      };
      bundleModel.getAppInfoList(appUid, (errCode: CMModelErrorCode, appInfo: AppInfoVo) => {
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          appInfoRet = appInfo;
        }
      })
      expect(appInfoRet.appName).assertEqual('');
    })

  })
}