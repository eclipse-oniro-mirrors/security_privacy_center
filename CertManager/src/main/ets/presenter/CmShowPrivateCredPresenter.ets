/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';
import { CredentialAbstractVo } from '../model/CertManagerVo/CredentialAbstractVo';
import { CredentialVo } from '../model/CertManagerVo/CredentialVo';

export default class CmShowPrivateCredPresenter {
  private static sInstance: CmShowPrivateCredPresenter;
  public credList: CredentialAbstractVo[] = [];
  public credInfo: CredentialVo = new CredentialVo('', '', '', 0, 0, new Uint8Array());

  public static getInstance(): CmShowPrivateCredPresenter {
    if (CmShowPrivateCredPresenter.sInstance == null) {
      CmShowPrivateCredPresenter.sInstance = new CmShowPrivateCredPresenter();
    }
    return CmShowPrivateCredPresenter.sInstance;
  }

  aboutToDisappear(): void {
    this.credList = [];
    this.credInfo = new CredentialVo('', '', '', 0, 0, new Uint8Array());
  }

  updatePrivateCredList(): void {
    certManagerModel.getCertOrCredList(CMModelOptType.CM_MODEL_OPT_PRIVATE_CRED,
      (errCode: CMModelErrorCode, credList: Array<CredentialAbstractVo>) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        credList.sort((certAbs, certAbsOther) => {
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
        console.error('updatePrivateCredList error :' + JSON.stringify(errCode));
        this.credList = [];
      }
    });
  }

  getPrivateCred(uri: string, callback: Function): void {
    certManagerModel.getCertOrCred(CMModelOptType.CM_MODEL_OPT_PRIVATE_CRED, uri,
      (errCode: CMModelErrorCode, credInfo: CredentialVo) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        this.credInfo = credInfo;
      } else {
        console.error('getPrivateCred error :' + JSON.stringify(errCode));
        this.credInfo.clearCredentialVo();
      }
      callback();
    });
  }
}