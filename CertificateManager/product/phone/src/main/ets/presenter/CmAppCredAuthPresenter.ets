/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import certManagerModel from '../model/CertMangerModel';
import BundleModel from '../model/BundleModel';
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';
import type { CredentialAbstractVo } from '../model/CertManagerVo/CredentialAbstractVo';
import router from '@system.router';

const TAG = 'CMAppCredAuthPresenter Presenter: ';
const SUCCESS = 0;
const FAIL = -1;

export default class CmAppCredAuthPresenter {
  private static sInstance: CmAppCredAuthPresenter;
  optType: CMModelOptType = CMModelOptType.CM_MODEL_OPT_UNKNOWN;
  credList: CredentialAbstractVo[] = [];
  appName: string = '';

  public static getInstance(): CmAppCredAuthPresenter {
    if (CmAppCredAuthPresenter.sInstance == null) {
      CmAppCredAuthPresenter.sInstance = new CmAppCredAuthPresenter();
    }
    return CmAppCredAuthPresenter.sInstance;
  }

  onAboutToAppear(): void {

  }

  aboutToDisappear(): void {
    this.optType = CMModelOptType.CM_MODEL_OPT_UNKNOWN;
    this.credList = [];
  }

  updateAppNameFromUid(uid): void {
    try {
      console.log('getAppNameFromUid start uid = ' + uid);
      BundleModel.getAppInfoList(Number(uid), (errCode, appInfo) => {
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          this.appName = appInfo.appName;
          console.log('getAppNameFromUid success, appName = ' + this.appName);
        } else {
          console.error('getAppNameFromUid fail, uid = ' + uid);
        }
      });
    } catch (err) {
      console.error('updateAppNameFromUid failed');
    }
  }

  updateAppCredList(): void {
    certManagerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_APP_CRED, (errCode, credList) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        this.credList = credList;
        console.log('updateSystemTrustedCertificateList inin :' + JSON.stringify(credList));
      } else {
        console.log('updateSystemTrustedCertificateList fail');
      }
    });
  }

  requestAuthorize(uri, appUid): void {
    console.log(TAG + 'requestAuthorize start uri :' + uri + 'appUid: ' + appUid);
    let want = globalThis.abilityWant;

    certManagerModel.setAppAuth(CMModelOptType.CM_MODEL_OPT_APP_CRED, uri, appUid,
      true, (errCode, data) => {
        router.clear();
        if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
          console.log('requestAuthorize success data: ' + data);
          want.parameters.authUri = data;
          globalThis.certManagerAbilityContext.terminateSelfWithResult({
            resultCode: SUCCESS,
            want: want
          });
        } else {
          console.log('requestAuthorize fail');
          globalThis.certManagerAbilityContext.terminateSelfWithResult({
            resultCode: FAIL,
            want: want
          });
        }
      });
  }

  cancelProcess(): void {
    console.log('cancelProcess start');
    router.clear();
    globalThis.certManagerAbilityContext.terminateSelfWithResult({
      resultCode: FAIL,
      want: globalThis.abilityWant
    });
  }
}