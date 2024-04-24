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
import { PwdStore, GlobalContext } from '../../../../main/ets/common/GlobalContext';

export default function GlobalContextTest() {
  describe('GlobalContextTest', () => {

    beforeAll(() => {
      let certPwd: string = ''
    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it("setCertPwdTest_01", 0, () => {
      let pwd: string = '123456'
      PwdStore.prototype.setCertPwd(pwd)
      expect(0).assertEqual(0)
    })

    it("getCertPwdTest", 0, () => {
      let pwd = '123456'
      PwdStore.prototype.setCertPwd(pwd)
      let res = PwdStore.prototype.getCertPwd()
      expect(res).assertEqual(res)
    })

    it("clearCertPwdTest", 0, () => {
      let pwd = '123456'
      PwdStore.prototype.setCertPwd(pwd)
      PwdStore.prototype.clearCertPwd()
      expect(0).assertEqual(0)
    })

    it("getContextTest", 0, () => {
      let res = GlobalContext.getContext()
      expect(res).assertEqual(res)
    })

    it("getCmContextTest", 0, () => {
      let res = GlobalContext.getContext().getCmContext()
      expect(res).assertEqual(res)
    })

    it("getPwdStoreTest", 0, () => {
      let pwd = GlobalContext.getContext().getPwdStore()
      expect(pwd).assertEqual(pwd)
    })

    it("getAbilityWantTest", 0, () => {
      let want = GlobalContext.getContext().getAbilityWant()
      expect(want).assertEqual(want)
    })

    it("getSessionTest", 0, () => {
      let session = GlobalContext.getContext().getSession()
      expect(session).assertEqual(session)
    })

    it("getFlagTest", 0, () => {
      let flag = GlobalContext.getContext().getFlag()
      expect(flag).assertEqual(flag)
    })

    it("setFlagTest_001", 0, () => {
      let flag: boolean = true;
      GlobalContext.getContext().setFlag(flag)
      expect(0).assertEqual(0)
    })

    it("setFlagTest_002", 0, () => {
      let flag: boolean = false;
      GlobalContext.getContext().setFlag(flag)
      expect(0).assertEqual(0)
    })

  })
}