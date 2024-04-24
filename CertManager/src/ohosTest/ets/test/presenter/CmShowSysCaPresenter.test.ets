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
import CmShowSysCaPresenter from '../../../../main/ets/presenter/CmShowSysCaPresenter';

export default function CmShowSysCaPresenterTest() {
  describe('CmShowSysCaPresenterTest', () => {

    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it("getInstanceTest001", 0, () => {
      let ret = CmShowSysCaPresenter.getInstance()
      expect(ret !== null).assertTrue();
    })

    it("updateSystemTrustedCertificateListTest001", 0, (done: Function) => {
      CmShowSysCaPresenter.getInstance().updateSystemTrustedCertificateList()
      expect(CmShowSysCaPresenter.getInstance().certList.length == 0).assertTrue();
      done();
    })

    it("getSystemTrustedCertificateTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowSysCaPresenter.getInstance().getSystemTrustedCertificate(uri, () => {
        expect(CmShowSysCaPresenter.getInstance().certInfo.uri == '').assertTrue();
        done();
      });

    })

    it("setSystemCertificateStatusTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      let status: boolean = true;
      CmShowSysCaPresenter.getInstance().setSystemCertificateStatus(uri, status);
      expect(0).assertEqual(0);
      done();
    })

  })
}