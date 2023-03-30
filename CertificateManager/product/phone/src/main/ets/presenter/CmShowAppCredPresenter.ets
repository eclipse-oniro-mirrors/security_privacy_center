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
import bundleModel from '../model/BundleModel';
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';
import type { CredentialAbstractVo } from '../model/CertManagerVo/CredentialAbstractVo';
import { CredentialVo } from '../model/CertManagerVo/CredentialVo';
import { AppAuthorVo } from '../model/CertManagerVo/AppAuthorVo';

export default class CmShowAppCredPresenter {
  private static sInstance: CmShowAppCredPresenter;
  credList: CredentialAbstractVo[] = [];
  appInfoList: AppAuthorVo[] = [];
  credInfo: CredentialVo = new CredentialVo('', '', '', 0, 0, null);

  public static getInstance(): CmShowAppCredPresenter {
    if (CmShowAppCredPresenter.sInstance == null) {
      CmShowAppCredPresenter.sInstance = new CmShowAppCredPresenter();
    }
    return CmShowAppCredPresenter.sInstance;
  }

  aboutToDisappear(): void {
    this.credList = [];
    this.credInfo = new CredentialVo('', '', '', 0, 0, null);
    this.appInfoList = [];
  }

  updateAppCredListCallback(callback): void {
    certManagerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_APP_CRED, (errCode, credList) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        credList.sort((certAbs, certAbsOther): number => {
          let certAlias = certAbs.alias;
          let certAliasOther = certAbsOther.alias;
          if (certAlias <= certAliasOther) {
            return -1;
          } else {
            return 1;
          }
        });
        this.credList = credList;
        callback();
      } else {
        console.log('updateAppCredList error :' + JSON.stringify(errCode));
        this.credList = [];
        callback();
      }
    });
  }

  updateAppCredList(): void {
    certManagerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_APP_CRED, (errCode, credList) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        credList.sort((certAbs, certAbsOther): number => {
          let certAlias = certAbs.alias;
          let certAliasOther = certAbsOther.alias;
          if (certAlias <= certAliasOther) {
            return -1;
          } else {
            return 1;
          }
        });
        this.credList = credList;
      } else {
        console.log('updateAppCredList error :' + JSON.stringify(errCode));
        this.credList = [];
      }
    });
  }

  getAppCred(uri): void {
    certManagerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, uri, (errCode, credInfo) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        this.credInfo = credInfo;
      } else {
        console.log('getAppCred error :' + JSON.stringify(errCode));
        this.credInfo.clearCredentialVo();
      }
    });
  }

  deleteAppCred(uri): void {
    certManagerModel.deleteCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, uri, (errCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        this.updateAppCredList();
      } else {
        console.log('deleteAppCred error :' + JSON.stringify(errCode));
      }
    });
  }

  getAuthorizedAppList(uri): void {
    this.appInfoList = [];
    certManagerModel.getAuthAppList(CMModelOptType.CM_MODEL_OPT_APP_CRED, uri, (errCode, appUidList) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        for (let i = 0; i < appUidList.length; i++) {
          bundleModel.getAppInfoList(Number(appUidList[i]), (errCode, appInfo) => {
            if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
              this.appInfoList.push(
                new AppAuthorVo(String(appInfo.appImage), String(appUidList[i]), String(appInfo.appName), true));
              console.log('appInfoList: ' + JSON.stringify(this.appInfoList));
            }
          });
        }
      } else {
        console.log('getAuthorizedAppList error :' + JSON.stringify(errCode));
        this.appInfoList = [];
      }
    });
  }

  async removeGrantedAppList(uri): Promise<void> {
    console.log('enter removeGrantedAppList');
    for (let i = 0; i < this.appInfoList.length; i++) {
      if (!this.appInfoList[i].status) {
        try {
          let res = await certManagerModel.setAppAuthPromise(CMModelOptType.CM_MODEL_OPT_APP_CRED, uri,
            this.appInfoList[i].uid, false);
          console.log('removeGrantedAppList succeed' + JSON.stringify(res));
        } catch (error) {
          console.log('removeGrantedAppList error :' + JSON.stringify(error));
        }
      }
    }
    console.log('leave removeGrantedAppList');
  }
}