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
import CmInstallPresenter from '../../../../main/ets/presenter/CmInstallPresenter'

export default function CmInstallPresenterTest() {
  describe('CmInstallPresenterTest', () => {

    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it("checkCertNameLengthTest_01", 0, () => {
      let uri: string = 'file://docs/storage/Users/currentUser/Documents/1df5a75f.pem';
      let alias: string = 'certTest';
      let suffix: string = 'pem';
      let pwd: string = '123456';
      CmInstallPresenter.getInstance().checkCertNameLength(uri, alias, suffix, pwd).then((data: number) => {
        expect(data).assertEqual(data)
      })
    })
    it("checkCertNameLengthTest_02", 0, () => {
      let uri: string = 'file://docs/storage/Users/currentUser/Documents/1df5a75f.pem';
      let alias: string = 'certAndCredInstallTestWhenTheNameManyLongAndNameLengthExceed64bits';
      let suffix: string = 'pem';
      let pwd: string = '123456';
      CmInstallPresenter.getInstance().checkCertNameLength(uri, alias, suffix, pwd).then((data: number) => {
        expect(data).assertEqual(data)
      })
    })
    it("AuthenticationPassword_01", 0, () => {
      let uri: string = 'file://docs/storage/Users/currentUser/Documents/1df5a75f.pem';
      let suffix: string = 'pem';
      let pwd: string = '123456';
      CmInstallPresenter.getInstance().AuthenticationPassword(uri, suffix, pwd).then((data: number) => {
        expect(data).assertEqual(data)
      })
    })
    it("AuthenticationPassword_02", 0, () => {
      let uri: string = 'file://docs/storage/Users/currentUser/Documents/1df5a75f.pem';
      let suffix: string = 'pem';
      let pwd: string = '111222';
      CmInstallPresenter.getInstance().AuthenticationPassword(uri, suffix, pwd).then((data: number) => {
        expect(data).assertEqual(data)
      })
    })

    it("getInstanceTest", 0, () => {
      let res = CmInstallPresenter.getInstance()
      expect(res).assertEqual(res)
    })

    it("updateCertFileTypeTest", 0, () => {
      let suffix: string = 'p12';
      CmInstallPresenter.getInstance().updateCertFileType(suffix)
      expect(0).assertEqual(0)
    })

  })
}