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
import { CredentialAbstractVo } from '../../../../main/ets/model/CertManagerVo/CredentialAbstractVo';
import CmShowAppCredPresenter from '../../../../main/ets/presenter/CmShowAppCredPresenter';

export default function CmShowAppCredPresenterTest() {
  describe('CmShowAppCredPresenterTest', () => {

    beforeAll(() => {
      let credList: CredentialAbstractVo[] = [];
    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it("getInstanceTest001", 0, () => {
      let ret = CmShowAppCredPresenter.getInstance()
      expect(ret !== null).assertTrue();
    })

    it("updateAppCredListCallbackTest001", 0, (done: Function) => {
      CmShowAppCredPresenter.getInstance().updateAppCredListCallback(() => {
        expect(CmShowAppCredPresenter.getInstance().credList.length == 0).assertTrue();
        done();
      })
    })

    it("updateAppCredListTest001", 0, (done: Function) => {
      CmShowAppCredPresenter.getInstance().updateAppCredList()
      expect(CmShowAppCredPresenter.getInstance().credList.length == 0).assertTrue();
      done();
    })

    it("getAppCredTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowAppCredPresenter.getInstance().getAppCred(uri, () => {
      })
      expect(CmShowAppCredPresenter.getInstance().credInfo.credType == '').assertTrue();
      done();
    })

    it("deleteAppCredTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowAppCredPresenter.getInstance().deleteAppCred(uri);
      expect(CmShowAppCredPresenter.getInstance().credList.length == 0).assertTrue();
      done();
    })

    it("getAuthorizedAppListTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowAppCredPresenter.getInstance().getAuthorizedAppList(uri);
      expect(CmShowAppCredPresenter.getInstance().appInfoList.length == 0).assertTrue();
      done();
    })

    it("removeGrantedAppListTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowAppCredPresenter.getInstance().removeGrantedAppList(uri);
      expect(0).assertEqual(0);
      done();
    })

  })
}