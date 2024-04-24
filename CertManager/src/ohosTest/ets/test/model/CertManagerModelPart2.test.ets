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
import * as commonParameter from '../utils/common_parameter'
import CertManager from '@ohos.security.certManager';
import CertMangerModel, { CMModelErrorCode, CMModelOptType } from '../../../../main/ets/model/CertMangerModel';

const TAG = 'CertManagerModelTestPart2'

export default function CertManagerModelTestPart2() {
  describe('CertManagerModelTestPart2', () => {
    let commonCredUri: string = '';
    beforeAll(async () => {
      let alias: string = 'commonCredAlias';
      let data: Uint8Array = commonParameter.eccCredData;
      let pwd: string = '123456';
      try {
        let result = await CertManager.installPublicCertificate(data, pwd, alias);
        if (result.uri !== undefined) {
          commonCredUri = result.uri;
        }
      } catch (error) {
        console.error(TAG + 'before all install app cred failed');
      }

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(async () => {
      try {
        await CertManager.uninstallAllUserTrustedCertificate();
        console.log(TAG + 'uninstallAllUserTrustedCertificate success');
        await CertManager.uninstallAllAppCertificate();
        console.log(TAG + 'uninstallAllAppCertificate success');
      }catch (error) {
        console.error(TAG + 'after all delete user ca cert or public cred');
      }

    })
    it("getAuthAppList_001", 0, async (done: Function) => {
      console.log(TAG + 'enter getAuthAppList001');
      let appUid: string = '12001';
      await CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_APP_CRED, commonCredUri, appUid, true,
        (errCode: CMModelErrorCode) => {
          console.log(TAG + 'setAppAuth true ret: ' + errCode);
          CertMangerModel.getAuthAppList(CMModelOptType.CM_MODEL_OPT_APP_CRED, commonCredUri,
            (errCode: CMModelErrorCode) => {
              expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
              console.log(TAG + 'getAuthAppList001 ret: ' + errCode);
              CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_APP_CRED, commonCredUri, appUid, false,
                (errCode: CMModelErrorCode) => {
                  console.log(TAG + 'setAppAuth false ret: ' + errCode);
                  done();
                })
            })
        })
    })

    it("getAuthAppList_002", 0, async (done: Function) =>  {
      console.log(TAG + 'enter getAuthAppList002');
      let uri: string = 'notexist';
      CertMangerModel.getAuthAppList(CMModelOptType.CM_MODEL_OPT_APP_CRED, uri,
        (errCode: CMModelErrorCode) => {
          expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
          console.log(TAG + 'getAuthAppList002 ret: ' + errCode);
          done();
        })
    })

    it("getAuthAppList_003", 0, async (done: Function) =>  {
      console.log(TAG + 'enter getAuthAppList003');
      let uri: string = 'getAuthAppList003';
      CertMangerModel.getAuthAppList(CMModelOptType.CM_MODEL_OPT_USER_CA, uri,
        (errCode: CMModelErrorCode) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_NOT_SUPPORT).assertTrue();
          console.log(TAG + 'getAuthAppList003 ret: ' + errCode);
          done();
        })
    })

    it("getAuthAppList_004", 0, async (done: Function) =>  {
      console.log(TAG + 'enter getAuthAppList004');
      let uri: string = 'getAuthAppList004';
      CertMangerModel.getAuthAppList(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA, uri,
        (errCode: CMModelErrorCode) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_NOT_SUPPORT).assertTrue();
          console.log(TAG + 'getAuthAppList004 ret: ' + errCode);
          done();
        })
    })

    it("getAuthAppList_005", 0, async (done: Function) =>  {
      console.log(TAG + 'enter getAuthAppList005');
      let uri: string = 'getAuthAppList005';
      CertMangerModel.getAuthAppList(CMModelOptType.CM_MODEL_OPT_UNKNOWN, uri,
        (errCode: CMModelErrorCode) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_UNKNOWN_OPT).assertTrue();
          console.log(TAG + 'getAuthAppList005 ret: ' + errCode);
          done();
        })
    })

    it("setAppAuthPromise_001", 0, async (done: Function) =>  {
      console.log(TAG + 'enter setAppAuthPromise001');
      let uid: string = '210001';
      try {
        let res = await CertMangerModel.setAppAuthPromise(CMModelOptType.CM_MODEL_OPT_APP_CRED, commonCredUri,
          uid, false);
        console.log(TAG + 'setAppAuthPromise001 success');
        await CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_APP_CRED, commonCredUri, uid, false,
          (errCode: CMModelErrorCode) => {
            console.log(TAG + 'setAppAuth false ret: ' + errCode);
            done();
          })
      }catch (error) {
        console.error(TAG + 'setAppAuthPromise001 failed');
        expect().assertFail();
        done();
      }
    })

    it("setAppAuthPromise_002", 0, async (done: Function) =>  {
      console.log(TAG + 'enter setAppAuthPromise002');
      let uid: string = '210001';
      let uri: string = 'notexistUri'
      try {
        let res = await CertMangerModel.setAppAuthPromise(CMModelOptType.CM_MODEL_OPT_APP_CRED, uri, uid, false);
        console.log(TAG + 'setAppAuthPromise002 failed');
        expect().assertFail();
        done();
      }catch (error) {
        console.error(TAG + 'setAppAuthPromise002 failed');
        done();
      }
    })

    it("setAppAuth_001", 0, async (done: Function) =>  {
      console.log(TAG + 'enter setAppAuth001');
      let uid: string = '310001';
      await CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_APP_CRED, commonCredUri, uid, true,
        (errCode: CMModelErrorCode, data: string) => {
          expect(data !== undefined).assertTrue();
          console.log(TAG + 'setAppAuth001 ret: ' + errCode);
          CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_APP_CRED, commonCredUri, uid, false,
            (errCode: CMModelErrorCode) => {
              console.log(TAG + 'setAppAuth false ret: ' + errCode);
              done();
            })
        })
    })

    it("setAppAuth_002", 0, async (done: Function) =>  {
      console.log(TAG + 'enter setAppAuth002');
      let uid: string = '310001';
      await CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_APP_CRED, commonCredUri, uid, false,
        (errCode: CMModelErrorCode, data: string) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
          console.log(TAG + 'setAppAuth002 ret: ' + errCode);
          done();
        })
    })

    it("setAppAuth_003", 0, async (done: Function) =>  {
      console.log(TAG + 'enter setAppAuth003');
      let uid: string = '310001';
      let uri: string = 'notexistUri';

      await CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_APP_CRED, uri, uid, true,
        (errCode: CMModelErrorCode, data: string) => {
          expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
          console.log(TAG + 'setAppAuth003 ret: ' + errCode);
          done();
        })
    })

    it("setAppAuth_004", 0, async (done: Function) =>  {
      console.log(TAG + 'enter setAppAuth004');
      let uid: string = '310001';
      let uri: string = 'setAppAuth004';

      await CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_USER_CA, uri, uid, true,
        (errCode: CMModelErrorCode, data: string) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_NOT_SUPPORT).assertTrue();
          console.log(TAG + 'setAppAuth004 ret: ' + errCode);
          done();
        })
    })

    it("setAppAuth_005", 0, async (done: Function) =>  {
      console.log(TAG + 'enter setAppAuth005');
      let uid: string = '310001';
      let uri: string = 'setAppAuth005';

      await CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA, uri, uid, true,
        (errCode: CMModelErrorCode, data: string) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_NOT_SUPPORT).assertTrue();
          console.log(TAG + 'setAppAuth005 ret: ' + errCode);
          done();
        })
    })

    it("setAppAuth_006", 0, async (done: Function) =>  {
      console.log(TAG + 'enter setAppAuth006');
      let uid: string = '310001';
      let uri: string = 'setAppAuth006';

      await CertMangerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_UNKNOWN, uri, uid, true,
        (errCode: CMModelErrorCode, data: string) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_UNKNOWN_OPT).assertTrue();
          console.log(TAG + 'setAppAuth006 ret: ' + errCode);
          done();
        })
    })

    it("installCertOrCred_001", 0, async (done: Function) => {
      console.log(TAG + 'enter installCertOrCred001');
      let alias: string = 'installCertOrCred001';
      let data: Uint8Array = commonParameter.userTrustedCert;
      let pwd: string = '123456';
      await CertMangerModel.installCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, alias, data, pwd,
        (errCode: CMModelErrorCode) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
          console.log(TAG + 'installCertOrCred001 ret: ' + errCode);
          done();
        })
    })

    it("installCertOrCred_002", 0, async (done: Function) => {
      console.log(TAG + 'enter installCertOrCred002');
      let alias: string = 'installCertOrCred002';
      let data: Uint8Array = commonParameter.invalidUserTrustedCert;
      let pwd: string = '123456';
      await CertMangerModel.installCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, alias, data, pwd,
        (errCode: CMModelErrorCode) => {
          expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
          console.log(TAG + 'installCertOrCred002 ret: ' + errCode);
          done();
        })
    })

    it("installCertOrCred_003", 0, async (done: Function) => {
      console.log(TAG + 'enter installCertOrCred003');
      let alias: string = 'installCertOrCred003';
      let data: Uint8Array = commonParameter.eccCredData;
      let pwd: string = '123456';
      await CertMangerModel.installCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, alias, data, pwd,
        (errCode: CMModelErrorCode) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
          console.log(TAG + 'installCertOrCred003 ret: ' + errCode);
          done();
        })
    })

    it("installCertOrCred_004", 0, async (done: Function) => {
      console.log(TAG + 'enter installCertOrCred004');
      let alias: string = 'installCertOrCred004';
      let data: Uint8Array = commonParameter.invalidCredInfo;
      let pwd: string = '123456';
      await CertMangerModel.installCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, alias, data, pwd,
        (errCode: CMModelErrorCode) => {
          expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
          console.log(TAG + 'installCertOrCred004 ret: ' + errCode);
          done();
        })
    })

    it("installCertOrCred_005", 0, async (done: Function) => {
      console.log(TAG + 'enter installCertOrCred005');
      let alias: string = 'installCertOrCred005';
      let data: Uint8Array = commonParameter.invalidCredInfo;
      let pwd: string = '123456';
      await CertMangerModel.installCertOrCred(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA, alias, data, pwd,
        (errCode: CMModelErrorCode) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_NOT_SUPPORT).assertTrue();
          console.log(TAG + 'installCertOrCred005 ret: ' + errCode);
          done();
        })
    })

    it("installCertOrCred_006", 0, async (done: Function) => {
      console.log(TAG + 'enter installCertOrCred006');
      let alias: string = 'installCertOrCred006';
      let data: Uint8Array = commonParameter.invalidCredInfo;
      let pwd: string = '123456';
      await CertMangerModel.installCertOrCred(CMModelOptType.CM_MODEL_OPT_UNKNOWN, alias, data, pwd,
        (errCode: CMModelErrorCode) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_UNKNOWN_OPT).assertTrue();
          console.log(TAG + 'installCertOrCred006 ret: ' + errCode);
          done();
        })
    })

  })
}