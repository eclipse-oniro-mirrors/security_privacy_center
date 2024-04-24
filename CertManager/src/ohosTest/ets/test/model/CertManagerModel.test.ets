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
import CertManager from '@ohos.security.certManager';
import CertMangerModel, { CMModelErrorCode, CMModelOptType } from '../../../../main/ets/model/CertMangerModel';
import { CertAbstractVo } from '../../../../main/ets/model/CertManagerVo/CertAbstractVo';
import { CertInfoVo } from '../../../../main/ets/model/CertManagerVo/CertInfoVo';
import * as commonParameter from '../utils/common_parameter'

const TAG = 'CertManagerModelTest'

export default function CertManagerModelTest() {
  describe('CertManagerModelTest', () => {
    let systemTrustedUri: string = '';
    let appKeyUri: string = '';
    let userTrustedUri: string = '';
    let privateTrustedUri: string = '';

    beforeAll(async () => {
      try {
        let systemTrustedResult = await CertManager.getSystemTrustedCertificateList();
        if (systemTrustedResult.certList === undefined) {
          console.error(TAG + 'CertManagerModelTest failed, undefined');
        } else {
          if (systemTrustedResult.certList.length > 0) {
            systemTrustedUri = systemTrustedResult.certList[0].uri;
          }
          console.info(TAG + 'systemTrustedUri: ' + systemTrustedUri);
        }

        let appResult = await CertManager.installPublicCertificate(commonParameter.eccCredData, '123456', 'certAlias');
        if (appResult.uri === undefined) {
          console.log(TAG + 'installAppCertificate failed');
        } else {
          appKeyUri = appResult.uri;
        }

        let userTrustedResult = await CertManager.installUserTrustedCertificate({
          inData: commonParameter.userTrustedCert,
          alias: 'alias'
        })
        if (userTrustedResult.uri === undefined) {
          console.log(TAG + 'installUserTrustedCertificate failed');
        } else {
          userTrustedUri = userTrustedResult.uri;
        }
      } catch (err) {
        console.error(TAG + `beforeAll get error is: ${err}`)
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
        await CertManager.uninstallAllAppCertificate()
        console.log(TAG + 'uninstallAllAppCertificate success');
      } catch (err) {
        console.error(TAG + 'afterAll delete user ca cert or public cred failed');
      }
    })

    it("getCertOrCredList001", 0, async (done: Function) => {
      CertMangerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA,
        (errCode: CMModelErrorCode, credList: Array<CertAbstractVo>) => {
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          console.log(TAG + 'getCertOrCredList001 success, errCode = ' + errCode);
          expect(credList != undefined).assertTrue()
          done()
        } else {
          console.log(TAG + 'getCertOrCredList001 failed, errCode = ' + errCode);
          expect().assertFail()
          done()
        }
      })
    })
    it("getCertOrCredList002", 0, (done: Function) => {
      CertMangerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_USER_CA,
        (errCode: CMModelErrorCode, credList: Array<CertAbstractVo>) => {
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          console.log(TAG + 'getCertOrCredList002 success, errCode = ' + errCode);
          expect(credList != undefined).assertTrue()
          done()
        } else {
          console.log(TAG + 'getCertOrCredList002 failed, errCode = ' + errCode);
          expect(credList === undefined).assertTrue()
          done()
        }
      })
    })
    it("getCertOrCredList003", 0, (done: Function) => {
      CertMangerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_APP_CRED,
        (errCode: CMModelErrorCode, credList: Array<CertAbstractVo>) => {
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          console.log(TAG + 'getCertOrCredList003 success, errCode = ' + errCode);
          expect(credList != undefined).assertTrue()
          done()
        } else {
          console.log(TAG + 'getCertOrCredList003 failed, errCode = ' + errCode);
          expect().assertFail()
          done()
        }
      })
    })
    it("getCertOrCredList005", 0, (done: Function) => {
      CertMangerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_UNKNOWN,
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_UNKNOWN_OPT).assertTrue()
        done()
      }
      )
    })
    it("getCertOrCredList006", 0, async (done: Function) => {
      CertMangerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_SYSTEM_CRED,
        (errCode: CMModelErrorCode, credList: Array<CertAbstractVo>) => {
          if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
            console.log(TAG + 'getCertOrCredList006 success, errCode = ' + errCode);
            expect(credList != undefined).assertTrue()
            done()
          } else {
            console.log(TAG + 'getCertOrCredList006 failed, errCode = ' + errCode);
            expect(credList === undefined).assertTrue()
            done()
          }
        })
    })
    it("getCertOrCred001", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA, systemTrustedUri,
        (errCode: CMModelErrorCode, certInfo: CertInfoVo) => {
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          expect(certInfo != undefined).assertTrue()
          done()
        } else {
          expect().assertFail()
          done()
        }
      })
    })
    it("getCertOrCred002", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA, '',
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_EXCEPTION).assertTrue()
        done()
      })
    })
    it("getCertOrCred003", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, userTrustedUri,
        (errCode: CMModelErrorCode, certInfo: CertInfoVo) => {
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          expect(certInfo != undefined).assertTrue()
          done()
        } else {
          expect(certInfo == undefined).assertTrue()
          done()
        }
      })
    })
    it("getCertOrCred004", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, '',
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_EXCEPTION).assertTrue()
        done()
      })
    })
    it("getCertOrCred005", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, appKeyUri,
        (errCode: CMModelErrorCode, certInfo: CertInfoVo) => {
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          expect(certInfo != undefined).assertTrue()
          done()
        } else {
          expect().assertFail()
          done()
        }
      })
    })
    it("getCertOrCred006", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, '',
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_EXCEPTION).assertTrue()
        done()
      })
    })
    it("getCertOrCred007", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_PRIVATE_CRED, '',
        (errCode: CMModelErrorCode) => {
        expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue()
        done()
      })
    })

    it("getCertOrCred008", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_SYSTEM_CRED, appKeyUri,
        (errCode: CMModelErrorCode, certInfo: CertInfoVo) => {
          if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
            expect(certInfo != undefined).assertTrue()
            done()
          } else {
            expect(certInfo === undefined).assertTrue()
            done()
          }
        })
    })
    it("getCertOrCred009", 0, async (done: Function) => {
      CertMangerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_SYSTEM_CRED, '',
        (errCode: CMModelErrorCode) => {
          expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_EXCEPTION).assertTrue()
          done()
        })
    })

    it("deleteCertOrCred001", 0, async (done: Function) => {
      CertMangerModel.deleteCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, '',
        (errCode: CMModelErrorCode) => {
        expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
        done()
      })
    })
    it("deleteCertOrCred002", 0, async (done: Function) => {
      CertMangerModel.deleteCertOrCred(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA, '',
        (errCode: CMModelErrorCode) => {
        expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
        done()
      })
    })
    it("deleteCertOrCred003", 0, async (done: Function) => {
      CertMangerModel.deleteCertOrCred(CMModelOptType.CM_MODEL_OPT_PRIVATE_CRED, '',
        (errCode: CMModelErrorCode) => {
        expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue();
        done()
      })
    })
    it("deleteCertOrCred004", 0, async (done: Function) => {
      CertMangerModel.deleteCertOrCred(CMModelOptType.CM_MODEL_OPT_UNKNOWN, '',
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_UNKNOWN_OPT).assertTrue();
        done()
      })
    })
    it("setCertStatus002", 0, async (done: Function) => {
      CertMangerModel.setCertStatus(CMModelOptType.CM_MODEL_OPT_USER_CA, '', true,
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_EXCEPTION).assertTrue()
        done()
      })
    })
    it("setCertStatus003", 0, async (done: Function) => {
      CertMangerModel.setCertStatus(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA, systemTrustedUri, true,
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue()
        done()
      })
    })
    it("setCertStatus004", 0, async (done: Function) => {
      CertMangerModel.setCertStatus(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA, '', true,
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_EXCEPTION).assertTrue()
        done()
      })
    })
    it("setCertStatus005", 0, async (done: Function) => {
      CertMangerModel.setCertStatus(CMModelOptType.CM_MODEL_OPT_APP_CRED, '', true,
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_NOT_SUPPORT).assertTrue()
        done()
      })
    })
    it("setCertStatus006", 0, async (done: Function) => {
      CertMangerModel.setCertStatus(CMModelOptType.CM_MODEL_OPT_PRIVATE_CRED, '', true,
        (errCode: CMModelErrorCode) => {
        expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue()
        done()
      })
    })
    it("setCertStatus007", 0, async (done: Function) => {
      CertMangerModel.setCertStatus(CMModelOptType.CM_MODEL_OPT_UNKNOWN, '', true,
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_UNKNOWN_OPT).assertTrue()
        done()
      })
    })
    it("delALlCertOrCred002", 0, async (done: Function) => {
      CertMangerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED,
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue()
        done()
      })
    })
    it("delALlCertOrCred003", 0, async (done: Function) => {
      CertMangerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_SYSTEM_CA,
        (errCode: CMModelErrorCode) => {
        expect(errCode === CMModelErrorCode.CM_MODEL_ERROR_NOT_SUPPORT).assertTrue()
        done()
      })
    })
    it("delALlCertOrCred004", 0, async (done: Function) => {
      CertMangerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_PRIVATE_CRED,
        (errCode: CMModelErrorCode) => {
        expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue()
        done()
      })
    })
    it("delALlCertOrCred005", 0, async (done: Function) => {
      CertMangerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_UNKNOWN,
        (errCode: CMModelErrorCode) => {
        expect(errCode !== CMModelErrorCode.CM_MODEL_ERROR_SUCCESS).assertTrue()
        done()
      })
    })
  })
}