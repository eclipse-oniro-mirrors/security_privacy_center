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
import CmShowUserCaPresenter from '../../../../main/ets/presenter/CmShowUserCaPresenter';

export default function CmShowUserCaPresenterTest() {
  describe('CmShowUserCaPresenterTest', () => {

    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it("getInstanceTest001", 0, () => {
      let ret = CmShowUserCaPresenter.getInstance()
      expect(ret !== null).assertTrue();
    })

    it("updateUserTrustedCertificateListTest001", 0, (done: Function) => {
      CmShowUserCaPresenter.getInstance().updateUserTrustedCertificateList()
      expect(CmShowUserCaPresenter.getInstance().certList.length == 0).assertTrue();
      done();
    })

    it("getUserTrustedCertificateTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowUserCaPresenter.getInstance().getUserTrustedCertificate(uri, () => {
        expect(CmShowUserCaPresenter.getInstance().certInfo.uri == '').assertTrue();
        done();
      });
    })

    it("setUserCertificateStatusTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      let status: boolean = true;
      CmShowUserCaPresenter.getInstance().setUserCertificateStatus(uri, status);
      expect(0).assertEqual(0);
      done();
    })

    it("deleteUserCertificateTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowUserCaPresenter.getInstance().deleteUserCertificate(uri, () => {
        expect(CmShowUserCaPresenter.getInstance().certInfo.uri == '').assertTrue();
        done();
      });
    })

  })
}