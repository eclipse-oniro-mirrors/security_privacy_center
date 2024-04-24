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
import CmShowSysCredPresenter from '../../../../main/ets/presenter/CmShowSysCredPresenter';

export default function CmShowSysCredPresenterTest() {
  describe('CmShowSysCredPresenterTest', () => {

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
      let ret = CmShowSysCredPresenter.getInstance()
      expect(ret !== null).assertTrue();
    })

    it("updateSystemCredListCallbackTest001", 0, (done: Function) => {
      CmShowSysCredPresenter.getInstance().updateSystemCredListCallback(() => {
        expect(CmShowSysCredPresenter.getInstance().credList.length == 0).assertTrue();
        done();
      })
    })

    it("updateSystemCredListTest001", 0, (done: Function) => {
      CmShowSysCredPresenter.getInstance().updateSystemCredList()
      expect(CmShowSysCredPresenter.getInstance().credList.length == 0).assertTrue();
      done();
    })

    it("getSystemCredTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowSysCredPresenter.getInstance().getSystemCred(uri, () => {
      })
      expect(CmShowSysCredPresenter.getInstance().credInfo.credType == '').assertTrue();
      done();
    })

    it("deleteSystemCredTest001", 0, (done: Function) => {
      let uri: string = 'oh:t=sk;o=test;u=100;a=20010014';
      CmShowSysCredPresenter.getInstance().deleteSystemCred(uri);
      expect(CmShowSysCredPresenter.getInstance().credList.length == 0).assertTrue();
      done();
    })
  })
}