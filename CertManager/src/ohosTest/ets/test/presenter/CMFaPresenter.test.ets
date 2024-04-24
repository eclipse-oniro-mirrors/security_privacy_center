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
import CmFaPresenter from '../../../../main/ets/presenter/CmFaPresenter';

export default function CMFaPresenterTest() {
  describe('CMFaPresenterTest', () => {

    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })

    it("getInstanceTest001", 0, () => {
      let ret = CmFaPresenter.getInstance()
      expect(ret !== null).assertTrue();
    })

    it("unrecognizedFileTipsTest_01", 0, () => {
      CmFaPresenter.getInstance().unrecognizedFileTips();
      expect().assertUndefined();
    })

    it("routeToNextInstallCertTest_01", 0, () => {
      let fileUri: string = 'file://docs/storage/Users/currentUser/Documents/40dc992e.pem';
      CmFaPresenter.getInstance().routeToNextInstallCert(fileUri);
      expect().assertUndefined();
    })

    it("routeToNextInstallCertTest_02", 0, () => {
      let fileUri: string = ''
      CmFaPresenter.getInstance().routeToNextInstallCert(fileUri);
      expect().assertUndefined();
    })

    it("routeToNextInstallEvidenceTest_01", 0, () => {
      let fileUri: string = 'file://docs/storage/Users/currentUser/Documents/temp.p12';
      CmFaPresenter.getInstance().routeToNextInstallEvidence(fileUri);
      expect().assertUndefined();
    })

    it("routeToNextInstallEvidenceTest_02", 0, () => {
      let fileUri: string = ''
      CmFaPresenter.getInstance().routeToNextInstallEvidence(fileUri);
      expect().assertUndefined();
    })

    it("startInstallCertTest_01", 0, () => {
      CmFaPresenter.getInstance().startInstallCert();
      expect().assertUndefined();
    })
    it("startInstallEvidenceTest_01", 0, () => {
      CmFaPresenter.getInstance().startInstallEvidence();
      expect().assertUndefined();
    })

    it("uninstallAllCertTest_01", 0, () => {
      CmFaPresenter.getInstance().uninstallAllCert();
      expect().assertUndefined();
    })

  })
}