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
import CheckUserAuthModel from '../../../../main/ets/model/CheckUserAuthModel';

export default function CheckUserAuthModelTest() {
  describe('CheckUserAuthModelTest', () => {

    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it("isAuthTypeSupportedTest_01", 0, () => {
      let authType: number = 1;
      let res = CheckUserAuthModel.isAuthTypeSupported(authType);
      expect(res).assertTrue();
    })

    it("isAuthTypeSupportedTest_02", 0, () => {
      let authType: number = 4;
      let res: boolean = CheckUserAuthModel.isAuthTypeSupported(authType);
      if (res) {
        expect(res).assertTrue();
      } else {
        expect(res).assertFalse();
      }
    })

    it("auth", 0, () => {
      let titleStr: string = '请进行身份认证';
      CheckUserAuthModel.auth(titleStr, data => {
        if (data) {
          expect(data).assertTrue();
        } else {
          expect(data).assertFalse();
        }
      })
    })
  })
}